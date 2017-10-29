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
        let commentUUID = UUID().uuidString
        guard let identifier = story.identifier else { return }
        let category = story.category.rawValue
        var newEndpoint = FirebaseController.databaseRef.child("\(String.storiesEndpoint)/\(String.categoryEndpoint)/\(category)/\(identifier)/\(String.commentsKey)")
        
        newEndpoint = newEndpoint.child(commentUUID)
        newEndpoint.updateChildValues(comment.dictionaryRepresentation)
    }
    
    func save(comment: Comment, toSnippet snippet: Snippet, completion: @escaping() -> Void) {
        defer { completion() }
        let commentUUID = UUID().uuidString
        guard let snippetUUID = snippet.identifier else { return }
        let category = snippet.category.rawValue
        var newEndpoint = FirebaseController.databaseRef.child("\(String.storiesEndpoint)/\(String.categoryEndpoint)/\(category)/\(snippet.storyRef)/\(String.snippetKey)/\(snippetUUID)/\(String.commentsKey)")
        
        newEndpoint = newEndpoint.child(commentUUID)
        newEndpoint.updateChildValues(comment.dictionaryRepresentation)
    }
    
    func fetchComments(fromStory story: Story, completion: @escaping([Comment]) -> Void) {
        guard let storyRef = story.identifier else { completion([]); return }
        let storyCategory = story.category
        let snippetRef = FirebaseController.databaseRef.child("\(String.storiesEndpoint)/\(String.categoryEndpoint)/\(storyCategory.rawValue)/\(storyRef)/\(String.commentsKey)")
        snippetRef.observe(.value, with: { (snapshot) in
            print(snapshot.description)
            guard let snapDictionary = snapshot.value as? [String: JSONDictionary] else { completion([]); return }
            let comments = snapDictionary.flatMap { Comment(dictionary: $1, identifier: $0) }.sorted(by: {$0.created < $1.created})
            
            completion(comments)
        })
    }
    
    func fetchComments(fromSnippets snippets: [Snippet], completion: @escaping([Comment]) -> Void) {
        var comments = [Comment]()
        var counter = snippets.count
        for snippet in snippets {
            DispatchQueue.global().async {
                guard let snippetUUID = snippet.identifier else { return }
                let category = snippet.category.rawValue
                let snippetRef = FirebaseController.databaseRef.child("\(String.storiesEndpoint)/\(String.categoryEndpoint)/\(category)/\(snippet.storyRef)/\(String.snippetKey)/\(snippetUUID)/\(String.commentsKey)")
                snippetRef.observe(.value, with: { (snapshot) in
                    guard let snapDictionary = snapshot.value as? [String: JSONDictionary] else { completion([]); return }
                    let snippetComments = snapDictionary.flatMap { Comment(dictionary: $1, identifier: $0) }.sorted(by: { $0.created < $1.created })
                    print(snapDictionary)
                    comments.append(contentsOf: snippetComments)
                    counter -= 1
                    if counter <= 0 {
                        completion(comments)
                    }
                })
            }
            
        }
     }
    
    func fetchSnippets(fromStory story: Story, completion: @escaping([Snippet])-> Void) {
        guard let storyRef = story.identifier else { completion([]); return }
        let storyCategory = story.category
        let snippetRef = FirebaseController.databaseRef.child("\(String.storiesEndpoint)/\(String.categoryEndpoint)/\(storyCategory.rawValue)/\(storyRef)/\(String.snippetKey)")
        snippetRef.observe(.value, with: { (snapshot) in
            print(snapshot.description)
            guard let snapDictionary = snapshot.value as? [String: JSONDictionary] else { completion([]); return }
            let snippets = snapDictionary.flatMap { Snippet(dictionary: $1, identifier: $0) }.sorted(by: {$0.created < $1.created})
            
            completion(snippets)
        })
    }
}
