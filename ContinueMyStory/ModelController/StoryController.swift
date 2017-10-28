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
        var story = Story(title: title, body: body, author: author, category: category)
        story.saveStory(toCategory: category)
        completion()
    }
    
    func fetchAllStories(completion: @escaping([Story]) -> Void) {
        let storiesRef = FirebaseController.databaseRef.child("\(String.storiesEndpoint)/\(String.categoryEndpoint)")
       storiesRef.observe(.value, with: { (snapshot) in
        
        guard let snapDictionary = snapshot.value as? [String: [String: JSONDictionary]] else { print("No dictionary resturned"); return }

        let catdict = snapDictionary.flatMap { $1 }

        let stories = catdict.flatMap { Story(dictionary: $1, identifier: $0) }.sorted(by: { $0.created < $1.created })
        
        completion(stories)
        })
    }
    
    func fetchStories(withCategory category: StoryCategory, completion: @escaping([Story]) -> Void) {
        let storiesRef = FirebaseController.databaseRef.child("\(String.storiesEndpoint)/\(String.categoryEndpoint)/\(category)")
        storiesRef.observe(.value, with: { (snapshot) in
            guard let snapDictionary = snapshot.value as? [String: JSONDictionary] else { return }
            let stories = snapDictionary.flatMap { Story(dictionary: $1, identifier: $0) }.sorted(by: { $0.created < $1.created})
            completion(stories)
        })
    }
    
    func fetchStories(withUser user: User, completion: @escaping([Story]) -> Void) {
        let storiesRef = FirebaseController.databaseRef.child("\(String.storiesEndpoint)/\(String.categoryEndpoint)")
        storiesRef.observe(.value, with: { (snapshot) in
        guard let snapDictionary = snapshot.value as? [String: [String: JSONDictionary]] else { print("No dictionary resturned"); return }
        let catDictionary = snapDictionary.flatMap { $1 }
            let stories = catDictionary.flatMap { Story(dictionary: $1, identifier: $0) }.filter { $0.author == user.identifier }
           
            completion(stories)
    })
    }
    
    func modify(story: Story, completion: @escaping() -> Void) {
        var newStory = story
        newStory.saveStory(toCategory: story.category)
    }
}
