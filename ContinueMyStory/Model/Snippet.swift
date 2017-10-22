//
//  Snippet.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/11/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import Foundation

class Snippet: FirebaseType {
    
    var body: String
    let author: String
    let storyRef: String
    var created: Date = Date()
    // this may become a model
    let comments: [String]?
    // snippets is of type string so it can hold the uid of the snippets saved.
    var endpoint: String = .snippetKey
    var identifier: String?
    var likes: [String]?
    let category: StoryCategory
    
    init(body: String, author: String, storyRef: String, comments: [String] = [], likes: [String] = [], category: StoryCategory) {
        self.body = body
        self.author = author
        self.storyRef = storyRef
        self.comments = comments
        self.likes = likes
        self.category = category
        
    }
    
    var dictionaryCopy: JSONDictionary {
        return [.bodyKey: body,
                .authorKey: author,
                .storyReferenceKey: storyRef,
                .createdKey: created.toString(),
                .likesKey: likes as Any,
                .categoryKey: category.rawValue]
    }
    
    required init?(dictionary: JSONDictionary, identifier: String) {
        guard let body = dictionary[.bodyKey] as? String,
            let author = dictionary[.authorKey] as? String,
            let storyRef = dictionary[.storyReferenceKey] as? String,
            let createdString = dictionary[.createdKey] as? String,
            let category = dictionary[.categoryKey] as? String,
            let created = createdString.date()
            else { return nil }
        self.identifier = identifier
        self.body = body
        self.author = author
        self.storyRef = storyRef
        self.created = created
        switch category {
        case StoryCategory.fantasy.rawValue: self.category = StoryCategory.fantasy
        case StoryCategory.sifi.rawValue: self.category = StoryCategory.sifi
        case StoryCategory.suspense.rawValue: self.category = StoryCategory.suspense
        case StoryCategory.crime.rawValue: self.category = StoryCategory.crime
        case StoryCategory.fable.rawValue: self.category = StoryCategory.fable
        case StoryCategory.fanFiction.rawValue: self.category = StoryCategory.fanFiction
        case StoryCategory.historicalFiction.rawValue: self.category = StoryCategory.historicalFiction
        case StoryCategory.horror.rawValue: self.category = StoryCategory.horror
        case StoryCategory.legend.rawValue: self.category = StoryCategory.legend
        case StoryCategory.mystery.rawValue: self.category = StoryCategory.mystery
        case StoryCategory.mythology.rawValue: self.category = StoryCategory.mythology
        case StoryCategory.romance.rawValue: self.category = StoryCategory.romance
        case StoryCategory.shortStory.rawValue: self.category = StoryCategory.shortStory
        case StoryCategory.tallTale.rawValue: self.category = StoryCategory.tallTale
        case StoryCategory.western.rawValue: self.category = StoryCategory.western
        default:
            self.category = StoryCategory.none
        }
        self.comments = dictionary[.commentsKey] as? [String]
        self.likes = dictionary[.likesKey] as? [String]
    }
}
