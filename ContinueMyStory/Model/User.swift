//
//  User.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/10/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import Foundation


struct User: FirebaseType {
    
    var username: String
    var email: String
    var givenName: String
    var familyName: String
    var age: Int
    var identifier: String?
    var endpoint: String = .usersEndpoint
    var dictionaryCopy: [String : Any] {
        return [.usernameKey: username,
                .emailKey: email,
                .givenNameKey: givenName,
                .familyNameKey: familyName,
                .ageKey: age]
    }
    
    init(username: String, email: String, givenName: String, familyName: String, age: Int, identifier: String = UUID().uuidString) {
        self.username = username
        self.email = email
        self.givenName = givenName
        self.familyName = familyName
        self.age = age
        self.identifier = identifier
    }
    
    init?(dictionary: JSONDictionary, identifier: String) {
        guard let username = dictionary[.usernameKey] as? String,
            let email = dictionary[.emailKey] as? String,
            let givenName = dictionary[.givenNameKey] as? String,
            let familyName = dictionary[.familyNameKey] as? String,
            let age = dictionary[.ageKey] as? Int else { return nil }
        self.identifier = identifier
        self.username = username
        self.email = email
        self.givenName = givenName
        self.familyName = familyName
        self.age = age
    }
}
