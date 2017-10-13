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
                .storyReferenceKey: storyRef]
    }
    
    required init?(dictionary: JSONDictionary, identifier: String) {
        guard let body = dictionary[.bodyKey] as? String,
            let author = dictionary[.authorKey] as? String,
            let storyRef = dictionary[.storyReferenceKey] as? String else { return nil }
        self.identifier = identifier
        self.body = body
        self.author = author
        self.storyRef = storyRef
        self.comments = dictionary[.commentsKey] as? [String]
        
    }
}
