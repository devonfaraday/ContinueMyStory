//
//  CommentTableViewCell.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/28/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    
    var comment: Comment? {
        didSet {
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func updateViews() {
        guard let comment = comment else { return }
        DispatchQueue.main.async {
            self.authorLabel.text = "\(comment.author) | \(comment.created.toStringWithoutSeconds())"
            self.bodyLabel.text = comment.body
        }
    }
    
}
