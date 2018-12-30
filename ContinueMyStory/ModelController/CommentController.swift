//
//  CommentController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/25/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import Foundation
import Firebase

class CommentController {
    
    func save(comment: Comment, toStory story: Story, completion: @escaping() -> Void) {
        defer { completion() }
        story.comments.append(comment)
        story.saveToFirestore()
    }
    
    func save(comment: Comment, toSnippet snippet: Snippet, completion: @escaping() -> Void) {
        defer { completion() }
        snippet.comments.append(comment)
        SnippetController().modifySnippet(with: snippet)
        completion()
    }
}
