//
//  SnippetController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/13/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import Foundation

class SnippetController {
    
    func createSnippet(withBody body: String, author: User, story: Story, completion: @escaping(Snippet) -> Void) {
        guard let storyRef = story.identifier else { return }
        let category = story.category
        var snippet = Snippet(body: body, author: author, storyRef: storyRef, category: story.category )
        snippet.saveSnippet(storyIdentifier: storyRef, storyCategory: category)
        completion(snippet)
    }
    
    func fetchSnippets(fromStory story: Story, completion: @escaping([Snippet])-> Void) {
        guard let storyRef = story.identifier else { completion([]); return }
        let storyCategory = story.category
        let snippetRef = FirebaseController.databaseRef.child("\(String.storiesEndpoint)/\(String.categoryEndpoint)/\(storyCategory.rawValue)/\(storyRef)/\(String.snippetKey)")
        snippetRef.observe(.value, with: { (snapshot) in
            print(snapshot.description)
            guard let snapDictionary = snapshot.value as? [String: JSONDictionary] else { completion([]); return }
            
            let snippets = snapDictionary.compactMap { Snippet(dictionary: $1, identifier: $0) }.sorted(by: {$0.created < $1.created})
            
            completion(snippets)
        })
    }
    
    func modify(snippet: Snippet, inStoryCategory category: StoryCategoryType, completion: @escaping() -> Void) {
        var newSnippet = snippet
        newSnippet.saveSnippet(storyIdentifier: newSnippet.storyRef, storyCategory: category)
    }
}


/*
 
 let storiesRef = FirebaseController.databaseRef.child("\(String.storiesEndpoint)/\(String.categoryEndpoint)")
 storiesRef.observe(.value, with: { (snapshot) in
 
 guard let snapDictionary = snapshot.value as? [String: [String: JSONDictionary]] else { print("No dictionary resturned"); return }
 
 let catdict = snapDictionary.compactMap { $1 }
 
 let stories = catdict.compactMap { Story(dictionary: $1, identifier: $0) }
 
 completion(stories)
 })
 }
 
 */
