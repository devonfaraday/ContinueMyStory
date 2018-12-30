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
                self.likeNumberLabel.text = "\(story.likes.count)"
            }
        } else if let snippet = snippet {
            DispatchQueue.main.async {
                self.bodyLabel.text = snippet.body
                self.likeNumberLabel.text = "\(snippet.likes.count)"
            }
        }
        DispatchQueue.main.async {
            self.authorLabel.text = "By: \(author.username)"
            // comment count will come from the count of array of comments
            self.commentNumberLabel.text = "\(self.story?.comments.count ?? self.snippet?.comments.count ?? 0)"
            
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
        guard let story = story
            else { return }
        if story.likes.contains(currentUserUID) {
            guard let index = story.likes.index(of: currentUserUID) else { return }
            story.likes.remove(at: index)
        } else {
            story.likes.append(currentUserUID)
        }
        
        let newLikes = story.likes
        DispatchQueue.main.async {
            self.likeNumberLabel.text = "\(newLikes.count)"
        }
        StoryController().modify(story: story) { (success) in
            print("Story Modified")
        }
    }
    
    func snippetLiked() {
        guard let snippet = snippet else { return }
        if snippet.likes.contains(currentUserUID) {
            guard let index = snippet.likes.index(of: currentUserUID) else { return }
            snippet.likes.remove(at: index)
        } else {
            snippet.likes.append(currentUserUID)
        }
        DispatchQueue.main.async {
            self.likeNumberLabel.text = "\(snippet.likes.count)"
        }
        
    }
}

protocol StoryTableViewCellDelegate: class {
//    func storySelectedForPresentation(_ sender: StoryTableViewCell)
    func storyTableCommentButtonTapped(_ sender: StoryTableViewCell)
    func storyCellAuthorButtonTapped(_ sender: StoryTableViewCell)
}
