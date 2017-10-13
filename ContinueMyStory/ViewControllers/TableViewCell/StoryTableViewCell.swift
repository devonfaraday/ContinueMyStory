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
    var user: User?
    
    func updateView() {
        guard let story = story,
            let user = user else { return }
        DispatchQueue.main.async {
            self.bodyLabel.text = story.body
            self.authorLabel.text = "By: \(user.username)"
        }
    }
    
    func fetchAuthor() {
        guard let authorid = story?.author else { return }
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
