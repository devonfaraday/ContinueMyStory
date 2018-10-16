//
//  Snippet.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/11/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import Foundation

class Snippet: FirebaseType, Equatable {
    
    var body: String
    let author: String
    let storyRef: String
    var created: Date = Date()
    // this may become a model
    var comments: [Comment]?
    // snippets is of type string so it can hold the uid of the snippets saved.
    var endpoint: String = .snippetKey
    var identifier: String?
    var likes: [String]?
    let category: StoryCategoryType
    
    init(body: String, author: String, storyRef: String, comments: [Comment] = [], likes: [String] = [], category: StoryCategoryType) {
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
        case StoryCategoryType.fantasy.rawValue: self.category = StoryCategoryType.fantasy
        case StoryCategoryType.sifi.rawValue: self.category = StoryCategoryType.sifi
        case StoryCategoryType.suspense.rawValue: self.category = StoryCategoryType.suspense
        case StoryCategoryType.crime.rawValue: self.category = StoryCategoryType.crime
        case StoryCategoryType.fable.rawValue: self.category = StoryCategoryType.fable
        case StoryCategoryType.fanFiction.rawValue: self.category = StoryCategoryType.fanFiction
        case StoryCategoryType.historicalFiction.rawValue: self.category = StoryCategoryType.historicalFiction
        case StoryCategoryType.horror.rawValue: self.category = StoryCategoryType.horror
        case StoryCategoryType.legend.rawValue: self.category = StoryCategoryType.legend
        case StoryCategoryType.mystery.rawValue: self.category = StoryCategoryType.mystery
        case StoryCategoryType.mythology.rawValue: self.category = StoryCategoryType.mythology
        case StoryCategoryType.romance.rawValue: self.category = StoryCategoryType.romance
        case StoryCategoryType.shortStory.rawValue: self.category = StoryCategoryType.shortStory
        case StoryCategoryType.tallTale.rawValue: self.category = StoryCategoryType.tallTale
        case StoryCategoryType.western.rawValue: self.category = StoryCategoryType.western
        default:
            self.category = StoryCategoryType.none
        }
        self.comments = dictionary[.commentsKey] as? [Comment]
        self.likes = dictionary[.likesKey] as? [String]
    }
}

func ==(lhs: Snippet, rhs: Snippet) -> Bool {
    return lhs.identifier == rhs.identifier
}
