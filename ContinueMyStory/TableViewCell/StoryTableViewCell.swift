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
    var story: Story? {
        didSet {
            fetchAuthor()
        }
    }
    var snippet: Snippet? {
        didSet {
            fetchAuthor()
        }
    }
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
            }
        } else if let snippet = snippet {
            DispatchQueue.main.async {
                self.bodyLabel.text = snippet.body
            }
        }
        DispatchQueue.main.async {
            self.authorLabel.text = "By: \(author.username)"
            // comment count will come from the count of array of comments
            self.commentNumberLabel.text = "\(0)"
            self.likeNumberLabel.text = "\(self.story?.likes?.count ?? 0)"
        }
    }
    
    @IBAction func commentButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func lightButtonTapped(_ sender: UIButton) {
        
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
    
    func fetchAuthor() {
        var authorid = ""
        if let story = story {
            authorid = story.author
        } else if let snippet = snippet {
            authorid = snippet.author
        }
        UserController().fetchUser(withIdentifier: authorid) { (author) in
            if let author = author {
                self.author = author
                self.updateView()
            }
        }
        
    }
}

protocol StoryTableViewCellDelegate: class {
    func storySelectedForPresentation(_ sender: StoryTableViewCell)
}
