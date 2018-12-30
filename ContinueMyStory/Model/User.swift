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
    
    var age: String?
    var collectionPathKey: String = .userscollectionPathKey
    var familyName: String
    var followers: [String] = []
    var following: [String] = []
    var stories: [String] = []
    var givenName: String
    var uid: String
    var profileImage: UIImage?
    var username: String
    var documentData: JSONDictionary {
        return [.usernameKey: username,
                .givenNameKey: givenName,
                .familyNameKey: familyName,
                .ageKey: age ?? "0",
                .followingKey: following,
                .followersKey: followers,
                .storyFollowingKey: stories,
                .identifierKey: uid as Any]
    }
    var fullName: String {
        return "\(givenName) \(familyName)"
    }
    
    init(username: String, givenName: String, familyName: String, age: String, uid: String ) {
        self.username = username
        self.givenName = givenName
        self.familyName = familyName
        self.age = age
        self.uid = uid
    }
    
    func setUserInUserDefaults() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(documentData, forKey: "user")
    }
    
    static func getCurrentUserFromUserDefaults() -> User? {
        let userDefaults = UserDefaults.standard
        guard let userDict = userDefaults.dictionary(forKey: "user") else { return nil }
        return User(dictionary: userDict)
    }
    
    init?(dictionary: JSONDictionary) {
        guard let username = dictionary[.usernameKey] as? String,
            let givenName = dictionary[.givenNameKey] as? String,
            let familyName = dictionary[.familyNameKey] as? String,
            let uid = dictionary[.identifierKey] as? String
        else { return nil }
        self.uid = uid
        self.username = username
        self.givenName = givenName
        self.familyName = familyName
        if let age = dictionary[.ageKey] as? String { self.age = age }
        if let followers = dictionary[.followersKey] as? [String] { self.followers = followers }
        if let following = dictionary[.followingKey] as? [String] { self.following = following }
        if let stories = dictionary[.storyFollowingKey] as? [String] { self.stories = stories }
    }
}

protocol CurrentUserUsable {}

extension CurrentUserUsable {
    var currentUser: User? {
        return User.getCurrentUserFromUserDefaults()
    }
}
