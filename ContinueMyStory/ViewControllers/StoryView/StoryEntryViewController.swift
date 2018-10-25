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
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var pageCountLabel: UILabel!
    @IBOutlet var profileImageButton: UIButton!
    @IBOutlet var storyContainerView: UIView!
    
    var author: User?
    var currentPageNumber: Int = 1
    var maxPageNumber: Int {
        guard let story = story else { return 0 }
        return story.snippets.count + 2
    }
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
            self.setProfileImageViewAttributes()
            self.updatePageNumber(toNumber: self.currentPageNumber)
            self.updateViewsHiddenState()
        }
    }
    
    func setProfileImageViewAttributes() {
        profileImageButton.layer.cornerRadius = profileImageButton.frame.width / 2
        profileImageButton.layer.borderWidth = 1.0
        profileImageButton.layer.borderColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.10).cgColor
    }

    func updateAuthor() {
        authorLabel.text = author?.fullName
    }
    
    func updateViewsHiddenState() {
        profileImageButton.isHidden = viewState == .continueMyStory
        authorLabel.isHidden = viewState == .continueMyStory
        likeButton.isHidden = viewState == .continueMyStory
        commentButton.isHidden = viewState == .continueMyStory
        pageCountLabel.isHidden = viewState == .continueMyStory
    }
    
    func updatePageNumber(toNumber aNumber: Int) {
        pageCountLabel.text = "\(aNumber)/\(maxPageNumber)"
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func commentButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func profileImageButtonTapped(_ sender: Any) {
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StoryPageViewController" {
            guard let storyPageViewController = segue.destination as? StoryPageViewController else { return }
            storyPageViewController.storyDelegate = self
            storyPageViewController.story = story
        }
    }
}

extension StoryEntryViewController: StoryDelegate {
    func storyPageDidTurn(toPageNumber pageNumber: Int) {
        updatePageNumber(toNumber: pageNumber)
    }
}

enum StoryEntryViewState {
    case story
    case snippet
    case continueMyStory
}
