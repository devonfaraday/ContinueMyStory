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
    
    func fetchAllStories(completion: @escaping([Story]) -> Void) {
        let storiesRef = FirebaseController.databaseRef.child("\(String.storiesEndpoint)/\(String.categoryEndpoint)")
       storiesRef.observe(.value, with: { (snapshot) in
        
        guard let snapDictionary = snapshot.value as? [String: [String: JSONDictionary]] else { print("No dictionary resturned"); return }

        let catdict = snapDictionary.flatMap { $1 }

        let stories = catdict.flatMap { Story(dictionary: $1, identifier: $0) }
        
        completion(stories)
        })
    }
    
    func fetchStories(withCategory category: StoryCategory, completion: @escaping([Story]) -> Void) {
        
    }
    
    func fetchStories(withUser user: User, completion: @escaping([Story]) -> Void) {
        
    }
}
