//
//  Comment.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/25/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import Foundation

struct Comment {
    
    var author: String
    var body: String
    var created: Date
    var storyRef: String?
    var snippetRef: String?
    
    init(author: String, body: String, created: Date = Date(), storyRef: String? = nil, snippetRef: String? = nil) {
        self.author = author
        self.body = body
        self.created = created
        self.storyRef = storyRef
        self.snippetRef = snippetRef
    }
    
    var dictionaryRepresentation: JSONDictionary {
        var returnDictionary = [String.authorKey: author,
                                String.bodyKey: body,
                                String.createdKey: created.toString()]
        if let storyRef = storyRef { returnDictionary[String.storyReferenceKey] = storyRef }
        if let snippetRef = snippetRef { returnDictionary[String.snippetReferenceKey] = snippetRef }
        return returnDictionary
        
    }
}

extension Comment {
    init?(dictionary: JSONDictionary, identifier: String) {
        guard let author = dictionary[.authorKey] as? String,
            let body = dictionary[.bodyKey] as? String,
            let created = dictionary[.createdKey] as? String,
            let date = created.date()
        else { return nil }
        let storyRef = dictionary[.storyReferenceKey] as? String
        let snippetRef = dictionary[.snippetReferenceKey] as? String
        self.author = author
        self.body = body
        self.created = date
        self.storyRef = storyRef
        self.snippetRef = snippetRef
    }
}
