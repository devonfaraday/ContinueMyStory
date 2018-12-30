//
//  InitialViewController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/17/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import UIKit
import Firebase

class InitialViewController: UIViewController {
    
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        checkAuthentication()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func checkAuthentication() {
        if Auth.auth().currentUser != nil {
            fetchCurrentUser {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: .toProfileViewControllerSegue, sender: self)
                }
            }
        } else {
            print("No User signed in")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: .toLoginViewControllerSegue, sender: self)
            }
            
        }
    }

        func fetchCurrentUser(completion: @escaping() -> Void) {
            guard let currentUser = Auth.auth().currentUser else { completion(); return }
            let uid = currentUser.uid
            UserController().fetchUser(withIdentifier: uid) { (user, error)  in
                print("User Fetched in profile")
                self.currentUser = user
                completion()
            }
        }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String.toProfileViewControllerSegue {
            guard let destination = segue.destination as? TabBar else { return }
            destination.currentUser = currentUser
        }
    }
    

}
