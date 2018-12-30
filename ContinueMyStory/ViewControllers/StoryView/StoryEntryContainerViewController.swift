//
//  StoryEntryContainerViewController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/16/18.
//  Copyright © 2018 Christian McMullin. All rights reserved.
//

import UIKit
import Firebase

class StoryEntryContainerViewController: UIViewController, UITextViewDelegate, CurrentUserUsable {

    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var cmsLabel: UILabel!
    @IBOutlet var continueMyStoryButton: UIButton!
    @IBOutlet var commentButton: UIButton!
    @IBOutlet var entryBodyTextView: UITextView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var pageNumberLabel: UILabel!
    @IBOutlet var profileImageButton: UIButton!
    @IBOutlet var followButton: UIButton!
    
    var author: User?
    var entryBody: String = ""
    var pageNumber: Int = 1
    var story: Story?
    var storyRef: String = ""
    var snippet: Snippet?
    var viewState: StoryEntryViewState = .story
    private var followState: FollowState = .follow
    
    private enum FollowState {
        case unfollow, hidden, follow, followBack
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAuthor()
        updateViews()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.black.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCommentNumber()
    }
    
    func fetchAuthor() {
        guard let author = author else { return }
        DispatchQueue.global().async {
            UserController().fetchUser(withIdentifier: author.uid) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else if user != nil {
                    self.author = user
                }
            }
        }
    }
    
    func fetchProfileImage() {
        let imageController = ImageController()
        DispatchQueue.global().async {
            imageController.fetchImage(forUser: self.author) { (image) in
                DispatchQueue.main.async {
                    self.profileImageButton.setBackgroundImage(image, for: .normal)
                    self.profileImageButton.setTitle("", for: .normal)
                }
            }
        }
    }
    
    func layoutProfileImageButton() {
        self.profileImageButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.09915453767)
        self.profileImageButton.layer.borderWidth = -2
        self.profileImageButton.layer.cornerRadius = self.profileImageButton.frame.width / 2
        self.profileImageButton.imageView?.layer.cornerRadius = self.profileImageButton.frame.width / 2
    }
    
    func updateViews() {
        layoutProfileImageButton()
        fetchProfileImage()
        updatePageNumber()
        updateEntryBodyTextView()
        updateForContinueMyStoryStateIfNeeded()
        updateAuthorInfo()
        updateLikeTitle()
        updateCommentNumber()
        updateFollowButton()
    }
    
    func updateCommentNumber() {
        let commentNumber = self.snippet != nil ? self.snippet?.comments.count ?? 0 : self.story?.comments.count ?? 0
        commentButton.setTitle("Comment \(commentNumber)", for: .normal)
    }
    
    func updateLikeTitle()  {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let likeNumber: Int = self.snippet != nil ? self.snippet?.likes.count ?? 0 : self.story?.likes.count ?? 0
        var likeTitle: String = ""
        if snippet != nil {
            likeTitle = snippet?.likes.contains(uid) == true ? "Unlike" : "Like"
        } else {
            likeTitle = story?.likes.contains(uid) == true ? "Unlike" : "Like"
        }
        likeButton.setTitle("\(likeTitle) \(likeNumber)", for: .normal)
    }
    
    func updatePageNumber() {
        pageNumberLabel.text = "\(pageNumber)"
    }
    
    func updateAuthorInfo() {
        guard let author: User = self.author
            else { return }
        authorLabel.text = author.username
    }
    
    func updateEntryBodyTextView() {
        entryBodyTextView.text = entryBody
        entryBodyTextView.isHidden = viewState == .continueMyStory
        entryBodyTextView.isEditable = false
        entryBodyTextView.isSelectable = false
    }
    
    func updateForContinueMyStoryStateIfNeeded() {
        cmsLabel.isHidden = viewState != .continueMyStory
        continueMyStoryButton.isHidden = viewState != .continueMyStory
        authorLabel.isHidden = viewState == .continueMyStory
        likeButton.isHidden = viewState == .continueMyStory
        commentButton.isHidden = viewState == .continueMyStory
        profileImageButton.isHidden = viewState == .continueMyStory
    }
    
    func updateFollowButton() {
        guard let author = author, let currentUser = currentUser else { return }
        if author.uid == currentUser.uid || viewState == .continueMyStory {
            followButton.isHidden = true
            followState = .hidden
        } else if currentUser.following.contains(author) {
            followButton.setTitle("Unfollow", for: .normal)
            followState = .unfollow
        } else if currentUser.followers.contains(author) {
            followButton.setTitle("Follow Back", for: .normal)
            followState = .followBack
        } else if !currentUser.following.contains(author) {
            followButton.setTitle("Follow", for: .normal)
            followState = .follow
        }
    }
    
    // MARK: - IBActions
    @IBAction func followButtonTapped(_ sender: Any) {
        switch followState {
        case .follow, .followBack:
            follow()
            followState = .unfollow
            updateFollowButton()
        case .hidden:
            print("Button hidden")
        case .unfollow:
            unfollow()
        }
    }
    
    func follow() {
        followButton.isEnabled = false
        guard var currentUser = currentUser, let author = author else { return }
        currentUser.following.append(author)
        currentUser.setUserInUserDefaults()
        currentUser.update { (success, error) in
            if success {
                self.author?.followers.append(currentUser)
                self.author?.update()
            }
            DispatchQueue.main.async {
                self.followButton.isEnabled = true
            }
        }
    }
    
    func unfollow() {
        followButton.isEnabled = false
        guard var currentUser = currentUser,
            let author = author,
            let followingIndex = currentUser.following.index(of: author)
            else { return }
        guard let followerIndex = author.followers.index(of: currentUser)
            else { return }
        self.author?.followers.remove(at: followerIndex)
        DispatchQueue.global().async {
            self.author?.update(completion: { (success, error) in
                if success {
                    currentUser.following.remove(at: followingIndex)
                    currentUser.setUserInUserDefaults()
                    currentUser.update()
                    self.followState = self.currentUser?.followers.contains(author) == true ? .followBack : .follow
                    self.updateFollowButton()
                }
                DispatchQueue.main.async {
                    self.followButton.isEnabled = true
                }
            })
        }
    }
    
    
    @IBAction func continueMyStoryButtonTapped(_ sender: Any) {
        self.author = User.getCurrentUserFromUserDefaults()
        viewState = .snippet
        updateViews()
        entryBodyTextView.isHidden = false
        continueMyStoryButton.isHidden = true
        cmsLabel.isHidden = true
        entryBodyTextView.isSelectable = true
        entryBodyTextView.isEditable = true
        entryBodyTextView.becomeFirstResponder()
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if viewState == .snippet, let snippet = self.snippet {
            guard let index = story?.snippets.index(of: snippet) else { return }
            if snippet.likes.contains(uid) {
                guard let index = snippet.likes.index(of: uid) else { return }
                story?.snippets[index].likes.remove(at: index)
            } else {
                story?.snippets[index].likes.append(uid)
            }
        } else {
            if story?.likes.contains(uid) == true {
                guard let index = story?.likes.index(of: uid) else { return }
                story?.likes.remove(at: index)
            } else {
                story?.likes.append(uid)
            }
        }
        guard let story = story else { return }
        StoryController().modify(story: story) { (success) in
            if success {
                print("Like saved")
                self.updateLikeTitle()
            }
        }
    }
    
    @IBAction func commentButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: .toCommentViewControllerSegue, sender: nil)
    }
    
    @IBAction func profileImageButtonTapped(_ sender: Any) {
        
    }
    
    // MARK: - TextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text?.count == 1000 {
            return false
        }
        if text == "\n",
            let body = textView.text,
            !body.isEmpty,
            let author = User.getCurrentUserFromUserDefaults(),
            let storyRef = story?.uid {
            self.author = author
            let snippet = Snippet(body: body, author: author, storyRef: storyRef)
            self.snippet = snippet
            story?.snippets.append(snippet)
            story?.update()
            entryBodyTextView.text = body
            textView.resignFirstResponder()
            textView.isEditable = false
        }
        return true
    }
    
    func updateViewsForAddingEntry() {
        entryBodyTextView.isSelectable = true
        entryBodyTextView.isEditable = true
        entryBodyTextView.becomeFirstResponder()
    }
    
    // MARK: - Navigation
    
    func segueToComments(with segue: UIStoryboardSegue, sender: Any?) {
        guard let commentVC = segue.destination as? CommentViewController else { return }
        commentVC.story = story
        commentVC.snippet = snippet
        commentVC.comments = snippet != nil ? snippet?.comments ?? [] : story?.comments ?? []
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case .toCommentViewControllerSegue?: segueToComments(with: segue, sender: sender)
        default:
            print("nothing to do")
        }
    }
}
