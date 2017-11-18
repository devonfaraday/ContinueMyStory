//
//  ProfileViewController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/10/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import UIKit
import Firebase

class BioViewController: UIViewController {

    @IBOutlet var editButton: UIButton!
    @IBOutlet var givenNameTextField: UITextField!
    @IBOutlet var familyNameTextfield: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var saveButtonStack: UIStackView!
    @IBOutlet var storyButtonStack: UIStackView!
    
    var profileState: ProfileViewState = .isEditing
    var currentUser: User? {
        didSet {
            if !isViewLoaded {
                loadViewIfNeeded()
            }
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        self.checkForCurrentUserInfo()
            DispatchQueue.main.async {
                self.setViewingState()
            }
        
    }
    
    // MARK: - IB Actions
    @IBAction func editButtonTapped(_ sender: UIButton) {
        profileState = .isEditing
        setViewingState()
    }
    
    @IBAction func createStoryButtonTapped(_ sender: UIButton) {
        
    }
    @IBAction func signOutButtonTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: .toLoginViewControllerSegue, sender: self)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func browseButtonTapped(_ sender: UIButton) {
        print("Browsing")
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        profileState = .isViewing
        setViewingState()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        createUser()
        profileState = .isViewing
        setViewingState()
    }
    
    // MARK: - View changes
    func setViewingState() {
        if profileState == .isViewing {
            setupViewForIsViewing(isViewing: true)
        } else {
            setupViewForIsViewing(isViewing: false)
        }
    }
    
    func setupViewForIsViewing(isViewing: Bool) {
        saveButtonStack.isHidden = isViewing
        usernameTextField.isEnabled = !isViewing
        givenNameTextField.isEnabled = !isViewing
        familyNameTextfield.isEnabled = !isViewing
        ageTextField.isEnabled = !isViewing
        storyButtonStack.isHidden = !isViewing
        editButton.isHidden = !isViewing
    }
    
    func checkForCurrentUserInfo() {
        if currentUser == nil {
            profileState = .isEditing
        } else {
            profileState = .isViewing
        }
    }
    
    func updateViews() {
        guard let user = currentUser else { return }
        usernameTextField.text = user.username
        givenNameTextField.text = user.givenName
        familyNameTextfield.text = user.familyName
        ageTextField.text = user.age
    }
    
    // MARK: - User Creation
    func createUser() {
        guard let username = usernameTextField.text,
            let givenName = givenNameTextField.text,
            let familyName = familyNameTextfield.text,
            let age = ageTextField.text else { return }
        UserController().createUser(withUsername: username, givenName: givenName, familyName: familyName, age: age)
    }
    
    
}
