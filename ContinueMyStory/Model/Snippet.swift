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
    
    init(body: String, author: String, storyRef: String, comments: [String] = []) {
        self.body = body
        self.author = author
        self.storyRef = storyRef
        self.comments = comments
        
    }
    
    var dictionaryCopy: JSONDictionary {
        return [.bodyKey: body,
                .authorKey: author,
                .storyReferenceKey: storyRef,
                .createdKey: created.toString()]
    }
    
    required init?(dictionary: JSONDictionary, identifier: String) {
        guard let body = dictionary[.bodyKey] as? String,
            let author = dictionary[.authorKey] as? String,
            let storyRef = dictionary[.storyReferenceKey] as? String,
            let createdString = dictionary[.createdKey] as? String,
            let created = createdString.date()
            else { return nil }
        self.identifier = identifier
        self.body = body
        self.author = author
        self.storyRef = storyRef
        self.created = created
        self.comments = dictionary[.commentsKey] as? [String]
        
    }
}
