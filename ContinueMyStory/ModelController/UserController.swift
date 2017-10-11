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
