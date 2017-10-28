//
//  StoryViewController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/11/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import UIKit
import Firebase

class StoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, StoryTableViewCellDelegate {
    
    
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var storyTitleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addSnippetView: UIView!
    @IBOutlet var addSnippetButton: UIButton!
    @IBOutlet var addSnippetTextView: UITextView!
    @IBOutlet var characterCountLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    
    var comments = [Comment]()
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
    var selectedStory: Story?
    var selectedSnippet: Snippet?
    var snippets = [Snippet]()
    var isAddingSnippet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureButtons()
        setInitialStoryView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        cell.delegate = self
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
    
    func storyTableCommentButtonTapped(_ sender: StoryTableViewCell) {
        if sender.story != nil {
            self.selectedStory = sender.story
        }
        if sender.snippet != nil {
            self.selectedSnippet = sender.snippet
        }
        performSegue(withIdentifier: .toCommentViewControllerSegue, sender: self)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        if isAddingSnippet {
            backButton.setTitle("Back", for: .normal)
            setInitialStoryView()
            addSnippetTextView.resignFirstResponder()
        } else {
            let _ = navigationController?.popViewController(animated: true)
        }
    }
    
    func setInitialStoryView() {
        isAddingSnippet = false
        addSnippetView.isHidden = true
        addSnippetTextView.isHidden = true
        characterCountLabel.isHidden = true
    }
    
    func configureButtons() {
        backButton.layer.cornerRadius = backButton.frame.width / 8
        backButton.layer.borderWidth = 2
        backButton.layer.borderColor = UIColor.black.cgColor
        addSnippetButton.layer.cornerRadius = addSnippetButton.frame.width / 8
        addSnippetButton.layer.borderWidth = 2
        addSnippetButton.layer.borderColor = UIColor.black.cgColor
        characterCountLabel.layer.borderWidth = 2
        characterCountLabel.layer.borderColor = UIColor.black.cgColor
    }
    
    func setAddingSnippetView() {
        characterCountLabel.isHidden = false
        characterCountLabel.text = "0/1000"
        backButton.setTitle("Cancel", for: .normal)
        addSnippetTextView.becomeFirstResponder()
        isAddingSnippet = true
        addSnippetView.isHidden = false
        addSnippetView.backgroundColor = .black
        addSnippetView.alpha = 0.5
        addSnippetTextView.isHidden = false
        addSnippetTextView.layer.borderWidth = 5
        addSnippetTextView.layer.borderColor = UIColor.black.cgColor
        addSnippetTextView.backgroundColor = .white
        
        
    }
    
    // MARK: - Text View Delegates
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        characterCountLabel.text = "\(numberOfChars)/1000"
        return numberOfChars < 1000 ;
    }
    
    
    // MARK: - Touches
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        addSnippetTextView.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String.toCommentViewControllerSegue {
            guard let destination = segue.destination as? CommentViewController else { return }
            if let selectedStory = selectedStory {
                destination.story = selectedStory
                if let comments = selectedStory.comments {
                    destination.comments = comments.sorted(by: { $0.created > $1.created })
                }
            } else if let selectedSnippet = selectedSnippet {
                destination.snippet = selectedSnippet
                if let comments = selectedSnippet.comments {
                    destination.comments = comments.sorted(by: { $0.created > $1.created })
                }
            }
        }
    }
}
