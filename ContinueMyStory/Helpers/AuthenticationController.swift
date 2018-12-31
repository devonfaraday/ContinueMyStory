//
//  AuthenticationController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/10/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import Foundation
import FirebaseAuth

struct FirebaseAuthentication {
    
    func createUser(withEmail email: String, username: String, password: String, completion: @escaping(_ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(error)
            } else if let uid = authDataResult?.user.uid {
                let user = User(username: username, givenName: "", familyName: "", age: "", uid: uid)
                user.saveToFirestore()
                user.setUserInUserDefaults()
                completion(nil)
            }
        }
    }
    
    func signIn(withEmail email: String, password: String, completion: @escaping(_ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            DispatchQueue.global().async {
                UserController().fetchCurrentUser()
            }
            if let error = error {
                print(error.localizedDescription)
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError {
            print(signOutError.localizedDescription)
        }
    }
    
}
