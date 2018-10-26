//
//  StoryTableViewCell.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/11/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import UIKit
import Firebase

class StoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet var commentNumberLabel: UILabel!
    @IBOutlet var likeNumberLabel: UILabel!
    
    var delegate: StoryTableViewCellDelegate?
    var story: Story?
    var snippet: Snippet?
    var author: User?
    var currentUserUID: String {
        guard let user = Auth.auth().currentUser else { return "" }
        return user.uid
    }
    
    func updateView() {
        guard let author = author else { return }
        
        if let story = story {
            DispatchQueue.main.async {
                self.bodyLabel.text = story.body
                self.likeNumberLabel.text = "\(self.story?.likes?.count ?? 0)"
            }
        } else if let snippet = snippet {
            DispatchQueue.main.async {
                self.bodyLabel.text = snippet.body
                self.likeNumberLabel.text = "\(self.snippet?.likes?.count ?? 0)"
            }
        }
        DispatchQueue.main.async {
            self.authorLabel.text = "By: \(author.username)"
            // comment count will come from the count of array of comments
            self.commentNumberLabel.text = "\(self.story?.comments?.count ?? self.snippet?.comments?.count ?? 0)"
            
        }
    }
    
    @IBAction func authorButtonTapped(_ sender: UIButton) {
        delegate?.storyCellAuthorButtonTapped(self)
    }
    
    @IBAction func commentButtonTapped(_ sender: UIButton) {
        delegate?.storyTableCommentButtonTapped(self)
    }
    
    @IBAction func lightButtonTapped(_ sender: UIButton) {
        if story != nil {
            storyLiked()
        } else {
            snippetLiked()
        }
    }
    
    func storyLiked() {
        if story?.likes == nil {
            story?.likes = []
        }
        guard let story = story,
            let likes = story.likes else { return }
        let modifiedStory = story
        
        if likes.contains(currentUserUID) {
            guard let index = likes.index(of: currentUserUID) else { return }
            modifiedStory.likes?.remove(at: index)
        } else {
            modifiedStory.likes?.append(currentUserUID)
        }
        
        if let newLikes = modifiedStory.likes {
            DispatchQueue.main.async {
                self.likeNumberLabel.text = "\(newLikes.count)"
            }
        }
        StoryController().modify(story: modifiedStory) {
            print("Story Modified")
        }
    }
    
    func snippetLiked() {
        if snippet?.likes == nil {
            snippet?.likes = []
        }
        guard let snippet = snippet,
            let likes = snippet.likes else { return }
        let modifiedSnippet = snippet
        if likes.contains(currentUserUID) {
            guard let index = likes.index(of: currentUserUID) else { return }
            modifiedSnippet.likes?.remove(at: index)
        } else {
            modifiedSnippet.likes?.append(currentUserUID)
        }
        
        if let newLikes = modifiedSnippet.likes {
            DispatchQueue.main.async {
                self.likeNumberLabel.text = "\(newLikes.count)"
            }
        }
        SnippetController().modify(snippet: modifiedSnippet, inStoryCategory: modifiedSnippet.category) {
            print("Snippet modified")
        }

    }
}

protocol StoryTableViewCellDelegate: class {
//    func storySelectedForPresentation(_ sender: StoryTableViewCell)
    func storyTableCommentButtonTapped(_ sender: StoryTableViewCell)
    func storyCellAuthorButtonTapped(_ sender: StoryTableViewCell)
}
