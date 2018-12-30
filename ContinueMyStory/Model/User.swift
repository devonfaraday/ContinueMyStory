//
//  User.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/10/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import Foundation
import Firebase

struct User: FirebaseType, Equatable {
    
    var age: String?
    var collectionPathKey: String = .userscollectionPathKey
    var familyName: String
    var followers: [User] = []
    var following: [User] = []
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
                .followingKey: following.compactMap({ $0.basicUserData }),
                .followersKey: followers.compactMap({ $0.basicUserData }),
                .storyFollowingKey: stories,
                .identifierKey: uid as Any]
    }
    var basicUserData: JSONDictionary {
        return [.usernameKey: username,
                .identifierKey: uid,
                .familyNameKey: familyName,
                .givenNameKey: givenName]
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
        if let followers = dictionary[.followersKey] as? [JSONDictionary] { self.followers = followers.compactMap({ User(dictionary: $0) }) }
        if let following = dictionary[.followingKey] as? [JSONDictionary] { self.following = following.compactMap({ User(dictionary: $0) }) }
        if let stories = dictionary[.storyFollowingKey] as? [String] { self.stories = stories }
    }
}

func ==(lhs: User, rhs: User) -> Bool {
    return lhs.uid == rhs.uid
}

protocol CurrentUserUsable {}

extension CurrentUserUsable {
    var currentUser: User? {
        return User.getCurrentUserFromUserDefaults()
    }
}
