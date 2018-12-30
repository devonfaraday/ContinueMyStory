//
//  UserController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/11/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import Foundation
import Firebase

//TODO: unfollow users and stories

class UserController {
    
    var user: User?
    func createUser(withUsername username: String, givenName: String, familyName: String, age: String) {
        var uid = ""
        if let currentUser = Auth.auth().currentUser {
            uid = currentUser.uid
        }
        let user = User(username: username, givenName: givenName, familyName: familyName, age: age, uid: uid)
        user.saveToFirestore { (success, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if success {
                print("Successfully created user")
            } else {
                print("failed to create user")
            }
        }
    }
    
    func followStory(withUser user: User, andStoryRef storyRef: String, completion: @escaping(User?) -> Void) {
        var modifiedUser = user
        if !modifiedUser.stories.contains(storyRef) {
        modifiedUser.stories.append(storyRef)
            modifiedUser.update { (success, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else if success {
                    print("Successfully modified user")
                } else {
                    print("failed to modify user")
                }
            }
            completion(modifiedUser)
        } else {
            completion(nil)
        }
    }
    
    func follow(user: User, withCurrentUser currentUser: User, completion: @escaping(User?) -> Void) {
        var modifiedUser = user
        var modifiedCurrentUser = currentUser
        if !modifiedUser.followers.contains(currentUser) {
            modifiedUser.followers.append(currentUser)
            modifyUser(user: modifiedUser)
        } else {
            print("You are already a follower of \(user.givenName)")
        }
        if !modifiedCurrentUser.following.contains(user) {
            modifiedCurrentUser.following.append(user)
            modifyUser(user: modifiedCurrentUser)
            completion(modifiedCurrentUser)
        } else {
            print("Already following \(user.givenName)")
            completion(nil)
        }
    }
    
    func modifyUser(user: User) {
        user.update { (success, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if success {
                print("Successfully modified user")
            } else {
                print("failed to modify user")
            }
        }
    }
    
    func fetchUser(withIdentifier uid: String, completion: @escaping(User?, Error?) -> Void) {
        let fc: FirebaseController = FirebaseController()
        fc.fetchDocument(fromCollection: .userscollectionPathKey, withUID: uid) { (jsonDictionary, error) in
            if let error = error {
                completion(nil, error)
            } else if let userDictionary = jsonDictionary {
                let user = User(dictionary: userDictionary)
                completion(user, nil)
            }
        }
    }
    
    func fetchCurrentUser(completion: @escaping(User?, Error?) -> Void) {
        guard let firebaseUser = Auth.auth().currentUser else { completion(nil, nil); return }
        let fc: FirebaseController = FirebaseController()
        fc.fetchDocument(fromCollection: .userscollectionPathKey, withUID: firebaseUser.uid) { (jsonDictionary, error) in
            if let error = error {
                completion(nil, error)
            } else if let userDictionary = jsonDictionary{
                let user = User(dictionary: userDictionary)
                user?.setUserInUserDefaults()
                completion(user, nil)
            }
        }
    }

    
} 
