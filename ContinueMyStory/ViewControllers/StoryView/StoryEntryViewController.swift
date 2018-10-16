//
//  StoryEntryViewController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/13/18.
//  Copyright © 2018 Christian McMullin. All rights reserved.
//

import UIKit

class StoryEntryViewController: UIViewController {

    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var commentButton: UIButton!
    @IBOutlet var continueMyStoryLabel: UILabel!
    @IBOutlet var continueMyStoryButton: UIButton!
    @IBOutlet var entryBodyTextView: UITextView!
    @IBOutlet var pageCountLabel: UILabel!
    @IBOutlet var profileImageButton: UIButton!
    @IBOutlet var likeButton: UIButton!
    
    var author: User?
    var currentPageNumber: Int = 1
    var maxPageNumber: Int = 1
    var snippet: Snippet?
    var story: Story?
    var viewState: StoryEntryViewState = .story
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAuther {
            self.authorLabel.text = self.author?.fullName
        }
        updateViews()
    }
    
    func fetchAuther(completion: @escaping() -> Void) {
        DispatchQueue.global().async {
            let userController: UserController = UserController()
            let uid = self.story?.author ?? self.snippet?.author ?? ""
            userController.fetchUser(withIdentifier: uid, completion: { (user) in
                self.author = user
                completion()
            })
        }
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.updateViewsForSnippet()
            self.updateViewsForStory()
            self.updateViewsForCMS()
            self.updatePageNumber()
            self.updateViewsHiddenState()
        }
    }
    
    func updateViewsForSnippet() {
        guard let snippet = self.snippet else { return }
        updateEntry(withBody: snippet.body)
        profileImageButton.setTitle("Profile\nImage\nHere", for: .normal)
    }
    
    func updateViewsForStory() {
        guard let story = self.story else { return }
        updateEntry(withBody: story.body)
    }
    
    func updateViewsForCMS() {
        if viewState == .continueMyStory {
            
        }
    }
    
    func updateAuthor() {
        authorLabel.text = author?.fullName
    }
    
    func updateViewsHiddenState() {
        profileImageButton.isHidden = viewState == .continueMyStory
        authorLabel.isHidden = viewState == .continueMyStory
        likeButton.isHidden = viewState == .continueMyStory
        commentButton.isHidden = viewState == .continueMyStory
        continueMyStoryLabel.isHidden = viewState != .continueMyStory
        continueMyStoryButton.isHidden = viewState != .continueMyStory
        pageCountLabel.isHidden = viewState == .continueMyStory
        entryBodyTextView.isHidden = viewState == .continueMyStory
    }
    
    func updatePageNumber() {
        pageCountLabel.text = "\(currentPageNumber)/\(maxPageNumber)"
    }
    
    func updateEntry(withBody body: String) {
        entryBodyTextView.text = body
        entryBodyTextView.isEditable = false
    }
    
    @IBAction func continueMyStoryButtonTapped(_ sender: Any) {
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
    }
    
    @IBAction func commentButtonTapped(_ sender: Any) {
    }
    
    
    @IBAction func profileImageButtonTapped(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    enum StoryEntryViewState {
        case story
        case snippet
        case continueMyStory
    }

}
