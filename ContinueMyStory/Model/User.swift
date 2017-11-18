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
    
    var age: String
    var endpoint: String = .usersEndpoint
    var familyName: String
    var followers: [String] = []
    var following: [String] = []
    var stories: [String] = []
    var givenName: String
    var identifier: String?
    var profileImage: UIImage?
    var username: String
    var dictionaryCopy: [String : Any] {
        return [.usernameKey: username,
                .givenNameKey: givenName,
                .familyNameKey: familyName,
                .ageKey: age]
    }
    var fullName: String {
        return "\(givenName) \(familyName)"
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
