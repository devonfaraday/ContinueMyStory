//
//  CreateStoryTableViewController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/11/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import UIKit
import Firebase

class CreateStoryTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var categoryPickerView: UIPickerView!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var storyBodyTextView: UITextView!
    
    var categories: [StoryCategory] = [.sifi, .fantasy, .suspense]
    var selectedCategory: StoryCategory?
    var userUid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storyBodyTextView.text = ""
        setUserUid()
    }
    
    // MARK: - IB Actions
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveStoryButtonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        createStory {
            sender.isEnabled = true
            sender.backgroundColor = .green
        }
    }
    
    // MARK: - Category Picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let category = categories[row]
        return category.rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let category = categories[row]
        selectedCategory = category
    }
    
    // MARK: - TextField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Touch Gesture
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        storyBodyTextView.resignFirstResponder()
    }
    
    // MARK: - Helpers
    func createStory(completion: @escaping() -> Void) {
        guard let title = titleTextField.text,
            let body = storyBodyTextView.text,
            let selectedCategory = selectedCategory else { return }
        StoryController().createStory(withTitle: title, body: body, author: userUid, category: selectedCategory) {
            print("Story saved")
            completion()
        }
    }
    
    func setUserUid() {
        guard let user = Auth.auth().currentUser else { return }
        userUid = user.uid
    }
    
}
