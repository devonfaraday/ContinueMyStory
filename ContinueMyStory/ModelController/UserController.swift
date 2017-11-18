//
//  UserController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/11/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import Foundation
import Firebase

class UserController {
    
    func createUser(withUsername username: String, givenName: String, familyName: String, age: String) {
        var uid = ""
        if let currentUser = Auth.auth().currentUser {
            uid = currentUser.uid
        }
        var user = User(username: username, givenName: givenName, familyName: familyName, age: age, identifier: uid)
        user.save()
    }
    
    func followStory(withUser user: User, andStoryRef storyRef: String, completion: @escaping(User?) -> Void) {
        var modifiedUser = user
        if !modifiedUser.stories.contains(storyRef) {
        modifiedUser.stories.append(storyRef)
        modifiedUser.save()
            completion(modifiedUser)
        } else {
            completion(nil)
        }
    }
    
    func follow(user: User, withCurrentUser currentUser: User, completion: @escaping(User?) -> Void) {
        var modifiedUser = user
        var modifiedCurrentUser = currentUser
        guard let currentUserUid = currentUser.identifier,
            let userUid = user.identifier
        else { return }
        
        if !modifiedUser.followers.contains(currentUserUid) {
            modifiedUser.followers.append(currentUserUid)
            modifiedUser.save()
        } else {
            print("You are already a follower of \(user.givenName)")
        }
        if !modifiedCurrentUser.following.contains(userUid) {
            modifiedCurrentUser.following.append(userUid)
            modifiedCurrentUser.save()
            completion(modifiedCurrentUser)
        } else {
            print("Already following \(user.givenName)")
            completion(nil)
        }
        
    }
    
    func fetchUser(withIdentifier identifier: String, completion: @escaping (User?) -> Void) {
        let userRef = FirebaseController.databaseRef.child(.usersEndpoint).child(identifier)
        userRef.observeSingleEvent(of: .value, with: { (data) in
            guard let userDict = data.value as? [String: Any] else {
                completion(nil)
                return
            }
            guard let user = User(dictionary: userDict, identifier: identifier) else { return }
            completion(user)
        })
    }
    
}
