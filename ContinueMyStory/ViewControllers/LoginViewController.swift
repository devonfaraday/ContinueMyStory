//
//  LoginViewController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/10/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var verifyPasswordTextField: UITextField!
    
    let firebaseAuthentication = FirebaseAuthentication()
    var loginState: LoginViewState = .login
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewsState()
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if loginState == .signUp {
            loginState = .login
            setViewsState()
        } else {
            login()
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        if loginState == .login {
            loginState = .signUp
            setViewsState()
        } else {
            signUp()
        }
    }
    
    // MARK: - Helpers
    
    func setViewsState() {
        if loginState == .login {
            verifyPasswordTextField.isHidden = true
            loginButton.setTitle("Login", for: .normal)
        } else if loginState == .signUp {
            verifyPasswordTextField.isHidden = false
            loginButton.setTitle("Cancel", for: .normal)
        }
    }
    
    // MARK: - Authentication Functions
    func login() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        firebaseAuthentication.signIn(withEmail: email, password: password) {
            print("Signed In")
        }
    }
    
    func signUp() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let verify = verifyPasswordTextField.text else { return }
        if password == verify {
            firebaseAuthentication.createUser(withEmail: email, password: password) {
                print("User Created")
            }
        } else {
            warningAlert(withTitle: "Something Went Wrong", message: "Your passwords don't match")
        }
    }
    
    // MARK: - Alert Controller
    func warningAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

enum LoginViewState {
    case login
    case signUp
}
