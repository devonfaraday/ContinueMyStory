//
//  StoryViewController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/11/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import UIKit
import Firebase

class StoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    @IBOutlet var buttonStackView: UIStackView!
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var storyTitleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addSnippetView: UIView!
    @IBOutlet var addSnippetButton: UIButton!
    @IBOutlet var addSnippetTextView: UITextView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var buttonStackBottomConstraint: NSLayoutConstraint!
    
    var story: Story?  {
        didSet {
            if !isViewLoaded {
                loadViewIfNeeded()
            }
                storyTitleLabel.text = story?.title
                guard let story = story else { return }
                SnippetController().fetchSnippets(fromStory: story, completion: { (snippets) in
                    self.snippets = snippets
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
        }
    }
    
    var snippets = [Snippet]()
    var isAddingSnippet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()
        setInitialStoryView()
//        setAutomaticDimensions()


    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return snippets.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: .storyCellIdentifier, for: indexPath) as? StoryTableViewCell else { return StoryTableViewCell() }
        if indexPath.section == 0 {
            if let story = story {
                cell.story = story
            }
        } else {
            if snippets.count > 0 {
                let snippet: Snippet? = snippets[indexPath.row]
                cell.snippet = snippet
            }
        }
        return cell
    }
    
    @IBAction func addSnippetButtonTapped(_ sender: UIButton) {
        if isAddingSnippet {
            if let body = addSnippetTextView.text,
                let authorID = Auth.auth().currentUser?.uid,
                let story = story {
                SnippetController().createSnippet(withBody: body, author: authorID, story: story, completion: { (snippet) in
                    self.snippets.append(snippet)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
            }
            setInitialStoryView()
        } else {
            setAddingSnippetView()
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        setInitialStoryView()
        addSnippetTextView.resignFirstResponder()
    }
    
    func setInitialStoryView() {
        isAddingSnippet = false
        addSnippetView.isHidden = true
        addSnippetTextView.isHidden = true
        cancelButton.isHidden = true
    }
    
    func setAddingSnippetView() {
        addSnippetTextView.becomeFirstResponder()
        isAddingSnippet = true
        addSnippetView.isHidden = false
        addSnippetView.backgroundColor = .black
        addSnippetView.alpha = 0.5
        addSnippetTextView.isHidden = false
        addSnippetTextView.layer.borderWidth = 5
        addSnippetTextView.layer.borderColor = UIColor.black.cgColor
        addSnippetTextView.backgroundColor = .white
        cancelButton.isHidden = false
        
    }
    
    // MARK: - Keyboard Methods
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, animations: {
                self.addSnippetView.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
                self.buttonStackView.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
            })
        }
    }

    //this puts the text fields in their origial position
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.addSnippetView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.buttonStackView.transform = CGAffineTransform(translationX: 0, y: 0)

        }
    }

    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - Text View Delegates
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        return numberOfChars < 1000 ;
    }

    
    // MARK: - Touches
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        addSnippetTextView.resignFirstResponder()
    }
}
