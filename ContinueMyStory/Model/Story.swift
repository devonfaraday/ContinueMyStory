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
    let comments: [String]?
    // snippets is of type string so it can hold the uid of the snippets saved.
    let category: StoryCategory
    let snippets: [String]?
    var endpoint: String = .storiesEndpoint
    var identifier: String?
    
    init(title: String, body: String, author: String, comments: [String] = [], category: StoryCategory, snippets: [String] = []) {
        self.title = title
        self.body = body
        self.author = author
        self.category = category
        self.comments = comments
        self.snippets = snippets
    }
    
    var dictionaryCopy: JSONDictionary {
        return [.titleKey: title,
                .bodyKey: body,
                .authorKey: author,
                .categoryKey: category.rawValue,
                .createdKey: created.toString()
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
        default:
            self.category = StoryCategory.none
        }
        self.comments = dictionary[.commentsKey] as? [String]
        self.snippets = dictionary[.snippetKey] as? [String]
    }
}


