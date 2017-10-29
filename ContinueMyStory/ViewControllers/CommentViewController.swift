//
//  CommentViewController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/25/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import UIKit
import Firebase

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var commentBottomConstraint: NSLayoutConstraint!
    
    var comments = [Comment]() {
        didSet {
            if !isViewLoaded {
                loadViewIfNeeded()
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var userID: String {
        var uuid = ""
        if let uid = Auth.auth().currentUser?.uid {
            uuid = uid
        }
        return uuid
    }
    var user: User?
    var story: Story?
    var snippet: Snippet?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserController().fetchUser(withIdentifier: userID) { (user) in
            guard let user = user else { return }
            self.user = user
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .commentCellIdentifier, for: indexPath)
        let comment = comments[indexPath.row]
        cell.textLabel?.text = comment.body
        cell.detailTextLabel?.text = "\(comment.author) | \(comment.created.toString())"
        return cell
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let body = commentTextView.text,
            let user = user
            else { return }
        let authorsFullName = "\(user.givenName) \(user.familyName)"
        
        if let story = story {
            let comment = Comment(author: authorsFullName, body: body, storyRef: story.identifier)
            saveToStory(withComment: comment)
        } else if let snippet = snippet {
            let comment = Comment(author: authorsFullName, body: body, snippetRef: snippet.identifier)
            saveToSnippet(withComment: comment)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
            let _ = navigationController?.popViewController(animated: true)
    }
    
    func saveToStory(withComment comment: Comment) {
        guard let story = story else { return }
        CommentController().save(comment: comment, toStory: story) {
            self.comments.insert(comment, at: 0)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func saveToSnippet(withComment comment: Comment) {
        guard let snippet = snippet else { return }
        CommentController().save(comment: comment, toSnippet: snippet) {
            self.comments.insert(comment, at: 0)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    
}
