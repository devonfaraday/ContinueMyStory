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
    
    @IBOutlet var storyTitleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addSnippetView: UIView!
    @IBOutlet var addSnippetButton: UIButton!
    @IBOutlet var addSnippetTextView: UITextView!
    @IBOutlet var cancelButton: UIButton!
    
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
        setInitialStoryView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
                let storyRef = story?.identifier {
                SnippetController().createSnippet(withBody: body, author: authorID, storyRef: storyRef, completion: { (snippet) in
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
    }
    
    func setInitialStoryView() {
        isAddingSnippet = false
        addSnippetView.isHidden = true
        addSnippetTextView.isHidden = true
        cancelButton.isHidden = true
    }
    
    func setAddingSnippetView() {
        isAddingSnippet = true
        addSnippetView.isHidden = false
        addSnippetView.backgroundColor = .white
        addSnippetView.alpha = 0.5
        addSnippetTextView.isHidden = false
        addSnippetTextView.layer.borderWidth = 5
        addSnippetTextView.layer.borderColor = UIColor.black.cgColor
        addSnippetTextView.backgroundColor = .white
        cancelButton.isHidden = false
        
    }
    
    // MARK: - Touches
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        addSnippetTextView.resignFirstResponder()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
