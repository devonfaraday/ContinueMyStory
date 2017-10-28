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
    
    init(author: String, body: String, created: Date = Date()) {
        self.author = author
        self.body = body
        self.created = created
    }
    
    var dictionaryRepresentation: JSONDictionary {
        return [String.authorKey: author,
                String.bodyKey: body,
                String.createdKey: created.toString()]
    }
}

extension Comment {
    init?(dictionary: JSONDictionary, identifier: String) {
        guard let author = dictionary[.authorKey] as? String,
            let body = dictionary[.bodyKey] as? String,
            let created = dictionary[.createdKey] as? String,
            let date = created.date()
        else { return nil }
        self.author = author
        self.body = body
        self.created = date
    }
}
