//
//  StoryController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/11/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import Foundation
import Firebase

class StoryController {
    
    func createStory(withTitle title: String, body: String, author: String, category: StoryCategory, completion: @escaping() -> Void) {
        var story = Story(title: title, body: body, author: author)
        story.saveStory(toCategory: category)
    }
    
}
