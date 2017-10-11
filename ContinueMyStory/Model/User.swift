//
//  User.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/10/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import Foundation
import Firebase


struct User: FirebaseType {
    
    var username: String
    var givenName: String
    var familyName: String
    var age: String
    var endpoint: String = .usersEndpoint
    var identifier: String?
    var dictionaryCopy: [String : Any] {
        return [.usernameKey: username,
                .givenNameKey: givenName,
                .familyNameKey: familyName,
                .ageKey: age]
    }
    
    init(username: String, givenName: String, familyName: String, age: String, identifier: String ) {
        self.username = username
        self.givenName = givenName
        self.familyName = familyName
        self.age = age
        self.identifier = identifier
    }
    
    init?(dictionary: JSONDictionary, identifier: String) {
        guard let username = dictionary[.usernameKey] as? String,
            let givenName = dictionary[.givenNameKey] as? String,
            let familyName = dictionary[.familyNameKey] as? String,
            let age = dictionary[.ageKey] as? String else { return nil }
        self.identifier = identifier
        self.username = username
        self.givenName = givenName
        self.familyName = familyName
        self.age = age
    }
}
