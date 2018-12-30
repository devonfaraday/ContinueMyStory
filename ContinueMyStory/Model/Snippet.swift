//
//  Snippet.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/11/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import Foundation

class Snippet: Equatable {
    
    var body: String
    var author: User?
    var authorUid: String? = nil
    let storyRef: String
    var created: Date = Date()
    // this may become a model
    var comments: [Comment]
    // snippets is of type string so it can hold the uid of the snippets saved.
    var collectionPathKey: String = .snippetsKey
    var uid: String
    var likes: [String]
    
    init(body: String, author: User, storyRef: String, comments: [Comment] = [], likes: [String] = []) {
        self.body = body
        self.author = author
        self.storyRef = storyRef
        self.comments = comments
        self.likes = likes
        self.uid = UUID().uuidString
    }
    
    var documentData: JSONDictionary {
        return [.bodyKey: body,
                .authorKey: author?.dataForStorySnippetComment as Any,
                .storyReferenceKey: storyRef,
                .createdKey: created.toString(),
                .likesKey: likes as Any,
                .identifierKey: uid]
    }
    
    required init?(dictionary: JSONDictionary) {
        guard let body = dictionary[.bodyKey] as? String,
            let storyRef = dictionary[.storyReferenceKey] as? String,
            let createdString = dictionary[.createdKey] as? String,
            let created = createdString.date(),
            let uid = dictionary[.identifierKey] as? String
            else { return nil }
        if let authorUid = dictionary["authorUid"] as? String { self.authorUid = authorUid }
        if let authorDict = dictionary[.authorKey] as? JSONDictionary {
            self.author = User(dictionary: authorDict)
        }
        self.uid = uid
        self.body = body
        self.storyRef = storyRef
        self.created = created
        self.comments = dictionary[.commentsKey] as? [Comment] ?? []
        self.likes = dictionary[.likesKey] as? [String] ?? []
    }
}

func ==(lhs: Snippet, rhs: Snippet) -> Bool {
    return lhs.uid == rhs.uid
}
