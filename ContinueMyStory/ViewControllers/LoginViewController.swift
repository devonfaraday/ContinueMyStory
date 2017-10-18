//
//  LoginViewController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/10/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var verifyPasswordTextField: UITextField!
    
    let firebaseAuthentication = FirebaseAuthentication()
    var loginState: LoginViewState = .login
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        setViewsState()
        resetTextFields()
        
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
        resetTextFields()
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
    
    func resetTextFields() {
        emailTextField.text = nil
        passwordTextField.text = nil
        verifyPasswordTextField.text = nil
    }
    
    
    
    // MARK: - Text Field Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if loginState == .login {
            if emailTextField.isFirstResponder {
                passwordTextField.becomeFirstResponder()
            } else {
                passwordTextField.resignFirstResponder()
            }
        } else {
            if emailTextField.isFirstResponder {
                passwordTextField.becomeFirstResponder()
            } else if passwordTextField.isFirstResponder {
                verifyPasswordTextField.becomeFirstResponder()
            } else {
                verifyPasswordTextField.resignFirstResponder()
            }
        }
        return true
    }
    
    // MARK: - Authentication Functions
    func login() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        firebaseAuthentication.signIn(withEmail: email, password: password) {
            print("Signed In")
            self.fetchCurrentUser {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: .toProfileViewControllerSegue, sender: self)
                    self.resetTextFields()
            }
        }
    }
    }
    
    func signUp() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let verify = verifyPasswordTextField.text else { return }
        if password == verify {
            firebaseAuthentication.createUser(withEmail: email, password: password) {
                print("User Created")
                self.loginState = .login
                self.setViewsState()
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
            }
        } else {
            warningAlert(withTitle: "Something Went Wrong", message: "Your passwords don't match")
        }
    }
    
    func fetchCurrentUser(completion: @escaping() -> Void) {
        guard let currentUser = Auth.auth().currentUser else { completion(); return }
        let uid = currentUser.uid
        UserController().fetchUser(withIdentifier: uid) { (user) in
            print("User Fetched in profile")
            self.currentUser = user
            completion()
        }
    }
    
    
    // MARK: - Alert Controller
    func warningAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationController = segue.destination as? ProfileViewController else { return }
            destinationController.currentUser = currentUser
    }
}


