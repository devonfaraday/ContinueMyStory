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
    
    func createStory(withTitle title: String, body: String, author: User, category: StoryCategoryType, completion: @escaping(_ success: Bool) -> Void) {
        let story = Story(title: title, body: body, author: author, category: category)
        story.saveToFirestore { (success, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            completion(success)
        }
    }
    
    func fetchAllStories(completion: @escaping([Story], Error?) -> Void) {
        let fc: FirebaseController = FirebaseController()
        fc.fetchAllDocuments(fromCollection: .storiescollectionPathKey) { (documents, error) in
            let stories = documents.compactMap({ Story(dictionary: $0) })
            completion(stories, error)
        }
    }
    
    func fetchStories(withCategory category: StoryCategoryType, completion: @escaping([Story], Error?) -> Void) {
        let fc: FirebaseController = FirebaseController()
        fc.fetchAllDocuments(fromCollection: .storiescollectionPathKey, whereField: .categorycollectionPathKey, isEqualTo: category.rawValue) { (documents, error) in
            let stories = documents.compactMap({ Story(dictionary: $0) })
            completion(stories, error)
        }
    }
    
    func fetchStories(withUser user: User, completion: @escaping([Story], Error?) -> Void) {
        let fc: FirebaseController = FirebaseController()
        fc.fetchAllDocuments(fromCollection: .storiescollectionPathKey, whereField: .authorKey, isEqualTo: user.basicUserData) { (documents, error) in
            let stories = documents.compactMap({ Story(dictionary: $0) })
            completion(stories, error)
        }
    }
    
    func modify(story: Story, completion: @escaping(_ success: Bool) -> Void) {
        story.update { (success, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            completion(success)
        }
    }
}
