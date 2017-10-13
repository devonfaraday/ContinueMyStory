//
//  SnippetController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/13/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import Foundation

class SnippetController {
    
    func createSnippet(withBody body: String, author: String, storyRef: String, completion: @escaping() -> Void) {
        var snippet = Snippet(body: body, author: author, storyRef: storyRef)
        snippet.saveSnippet(storyIdentifier: storyRef)
    }
    
    func fetchSnippets(fromStory story: Story, completion: @escaping([Snippet])-> Void) {
        guard let storyRef = story.identifier else { completion([]); return }
        let snippetRef = FirebaseController.databaseRef.child("\(String.storiesEndpoint)/\(String.snippetKey)/\(storyRef)")
        snippetRef.observe(.value, with: { (snapshot) in
            guard let snapDictionary = snapshot.value as? [String: JSONDictionary] else { completion([]); return }
            let snipptDictionary = snapDictionary.flatMap { $1 }
            print(snipptDictionary)
            completion([])
        })
    }
}


/*
 
 let storiesRef = FirebaseController.databaseRef.child("\(String.storiesEndpoint)/\(String.categoryEndpoint)")
 storiesRef.observe(.value, with: { (snapshot) in
 
 guard let snapDictionary = snapshot.value as? [String: [String: JSONDictionary]] else { print("No dictionary resturned"); return }
 
 let catdict = snapDictionary.flatMap { $1 }
 
 let stories = catdict.flatMap { Story(dictionary: $1, identifier: $0) }
 
 completion(stories)
 })
 }
 
 */
