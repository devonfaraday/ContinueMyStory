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
    
    
    func createUser(withEmail email: String, password: String, completion: @escaping() -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                
            }
            completion()
        }
    }
    
}
