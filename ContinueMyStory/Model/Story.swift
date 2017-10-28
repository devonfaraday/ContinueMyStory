//
//  Story.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/10/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import Foundation

class Story: FirebaseType {
    
    var title: String
    var body: String
    let author: String
    var created: Date = Date()
    // this may become a model
    var comments: [Comment]?
    // snippets is of type string so it can hold the uid of the snippets saved.
    var category: StoryCategory
    let snippets: [String]?
    var endpoint: String = .storiesEndpoint
    var identifier: String?
    var likes: [String]?
    
    init(title: String, body: String, author: String, comments: [Comment] = [], category: StoryCategory, snippets: [String] = [], likes: [String] = []) {
        self.title = title
        self.body = body
        self.author = author
        self.category = category
        self.comments = comments
        self.snippets = snippets
        self.likes = likes
    }
    
    var dictionaryCopy: JSONDictionary {
        return [.titleKey: title,
                .bodyKey: body,
                .authorKey: author,
                .categoryKey: category.rawValue,
                .createdKey: created.toString(),
                .likesKey: likes as Any
        ]
    }
    
    required init?(dictionary: JSONDictionary, identifier: String) {
        guard let title = dictionary[.titleKey] as? String,
            let body = dictionary[.bodyKey] as? String,
            let author = dictionary[.authorKey] as? String,
            let category = dictionary[.categoryKey] as? String,
            let dateString = dictionary[.createdKey] as? String,
            let date = dateString.date()
            else { return nil }
        self.identifier = identifier
        self.title = title
        self.body = body
        self.author = author
        self.created = date
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
        self.comments = dictionary[.commentsKey] as? [Comment]
        self.snippets = dictionary[.snippetKey] as? [String]
        self.likes = dictionary[.likesKey] as? [String]
    }
}


