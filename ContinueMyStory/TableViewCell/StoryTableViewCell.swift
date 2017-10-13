//
//  StoryTableViewCell.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/11/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import UIKit

class StoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
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
    var user: User?
    
    func updateView() {
        guard let user = user else { return }
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
            self.authorLabel.text = "By: \(user.username)"
        }
    }
    
    func fetchAuthor() {
        var authorid = ""
        if let story = story {
            authorid = story.author
        } else if let snippet = snippet {
            authorid = snippet.author
        }
        UserController().fetchUser(withIdentifier: authorid) { (user) in
            if let user = user {
                self.user = user
                self.updateView()
            }
        }
        
    }
}

protocol StoryTableViewCellDelegate: class {
    func storySelectedForPresentation(_ sender: StoryTableViewCell)
}
