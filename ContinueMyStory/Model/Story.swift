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
    let author: User?
    var created: Date = Date()
    var comments: [Comment] = []
    var category: StoryCategoryType
    var snippets: [Snippet]
    var collectionPathKey: String = .storiescollectionPathKey
    var uid: String
    var likes: [String] = []
    
    init(title: String, body: String, author: User, comments: [Comment] = [], category: StoryCategoryType, snippets: [Snippet] = [], likes: [String] = []) {
        self.title = title
        self.body = body
        self.author = author
        self.category = category
        self.comments = comments
        self.snippets = snippets
        self.likes = likes
        self.uid = UUID().uuidString
    }
    
    var documentData: JSONDictionary {
        return [.titleKey: title,
                .bodyKey: body,
                .authorKey: author?.documentData as Any,
                .categoryKey: category.rawValue,
                .createdKey: created.toString(),
                .likesKey: likes as Any
        ]
    }
    
    required init?(dictionary: JSONDictionary) {
        guard let title = dictionary[.titleKey] as? String,
            let body = dictionary[.bodyKey] as? String,
            let author = dictionary[.authorKey] as? JSONDictionary,
            let category = dictionary[.categoryKey] as? String,
            let dateString = dictionary[.createdKey] as? String,
            let date = dateString.date(),
            let uid = dictionary[.identifierKey] as? String
            else { return nil }
        self.author = User(dictionary: author)
        if let snippetsDictioanry = dictionary[.snippetKey] as? JSONDictionary {
            self.snippets = snippetsDictioanry.compactMap({
                guard let value = $0.value as? JSONDictionary else { return nil }
                return Snippet(dictionary: value)
            })
        } else {
            self.snippets = []
        }
        self.uid = uid
        self.title = title
        self.body = body
        self.created = date
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
        if let comments = dictionary[.commentsKey] as? [Comment] { self.comments = comments }
        if let likes = dictionary[.likesKey] as? [String] { self.likes = likes }
    }
}


