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
    @IBOutlet var usernameStack: UIStackView!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var verifyUnderlineView: UIView!
    @IBOutlet var verifyPasswordTextField: UITextField!
    
    let firebaseAuthentication = FirebaseAuthentication()
    var loginState: LoginViewState = .login
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        verifyPasswordTextField.isHidden = false
        verifyUnderlineView.isHidden = false
        usernameStack.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    }
    
    // MARK: - Helpers
    func setViewsState() {
        if loginState == .login {
            verifyPasswordTextField.isHidden = true
            verifyUnderlineView.isHidden = true
            usernameStack.isHidden = true
            loginButton.setTitle("Login", for: .normal)
        } else if loginState == .signUp {
            usernameStack.isHidden = false
            verifyPasswordTextField.isHidden = false
            verifyUnderlineView.isHidden = false
            loginButton.setTitle("Cancel", for: .normal)
        }
    }
    
    func resetTextFields() {
        emailTextField.text = nil
        passwordTextField.text = nil
        verifyPasswordTextField.text = nil
        usernameTextField.text = nil
    }
    
    // MARK: - Text Field Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if loginState == .login {
            emailTextField.isFirstResponder == true ?
                passwordTextField.becomeFirstResponder() :
                passwordTextField.resignFirstResponder()
        } else {
            switch textField {
            case emailTextField:
                usernameTextField.becomeFirstResponder()
            case usernameTextField:
                passwordTextField.becomeFirstResponder()
            case passwordTextField:
                verifyPasswordTextField.becomeFirstResponder()
            default:
                textField.resignFirstResponder()
                signUp()
            }
        }
        return true
    }
    
    // MARK: - Authentication Functions
    func handleSuccessfullLogin() {
        self.fetchCurrentUser { _ in
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: .toProfileViewControllerSegue, sender: self)
                self.resetTextFields()
            }
        }
    }
    
    func login() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        firebaseAuthentication.signIn(withEmail: email, password: password) { (error) in
            if let error = error {
                print(error.localizedDescription)
                self.warningAlert(withTitle: "Invalid Credentials", message: "Your email and/or password are incorrect")
            } else {
                print("Signed In")
                self.handleSuccessfullLogin()
            }
        }
    }
    
    func signUp() {
        guard let email = emailTextField.text,
            let username = usernameTextField.text,
            let password = passwordTextField.text,
            let verify = verifyPasswordTextField.text else { self.warningAlert(withTitle: "Missing info", message: "Please check your info and try again"); return }
        if password == verify {
            FirebaseController().fetchAllDocuments(fromCollection: .userscollectionPathKey, whereField: .usernameKey, isEqualTo: username) { (documentData, error) in
                let users = documentData.compactMap({ User(dictionary: $0) })
                if users.isEmpty {
                    self.firebaseAuthentication.createUser(withEmail: email, username: username, password: password, completion: { (error) in
                        if let error = error {
                            print(error.localizedDescription)
                            self.warningAlert(withTitle: "Error", message: error.localizedDescription)
                        } else {
                            print("User Created")
                            self.loginState = .login
                            self.setViewsState()
                            self.emailTextField.text = ""
                            self.passwordTextField.text = ""
                            self.handleSuccessfullLogin()
                        }
                    })
                } else {
                    DispatchQueue.main.async {
                        self.warningAlert(withTitle: "name taken", message: "\(username) is already taken.  Please choose a new username.")
                    }
                }
            }
        } else {
            warningAlert(withTitle: "Something Went Wrong", message: "Your passwords don't match")
        }
    }
    
    func fetchCurrentUser(completion: @escaping(Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { completion(nil); return }
        let uid = currentUser.uid
        UserController().fetchUser(withIdentifier: uid) { (user, error) in
            print("User Fetched in profile")
            self.currentUser = user
            completion(error)
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
        guard let destinationController = segue.destination as? BioViewController else { return }
        destinationController.currentUser = currentUser
    }
}


