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
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        setupCommentTextView()
        UserController().fetchUser(withIdentifier: userID) { (user, error) in
            guard let user = user else { return }
            self.user = user
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: .commentCellIdentifier, for: indexPath) as? CommentTableViewCell else { return CommentTableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: .commentCellIdentifier, for: indexPath)
        let comment = comments[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = comment.body
        cell.detailTextLabel?.text = "\(comment.author.username) | \(comment.created.toStringWithoutSeconds())"
        return cell
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let body = commentTextView.text,
            let user = user
            else { return }
        if let snippet = snippet {
            let comment = Comment(author: user, body: body, snippetRef: snippet.uid)
            self.comments.insert(comment, at: 0)
            saveToSnippet(withComment: comment)
        } else if let story = story {
            let comment = Comment(author: user, body: body, storyRef: story.uid)
            self.comments.insert(comment, at: 0)
            saveToStory(withComment: comment)
        }
        commentTextView.text = ""
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
            self.dismiss(animated: true, completion: nil)
    }
    
    func saveToStory(withComment comment: Comment) {
        guard let story = story else { return }
        story.comments.insert(comment, at: 0)
        story.update()
    }
    
    func saveToSnippet(withComment comment: Comment) {
        guard let snippet = snippet, let index = story?.snippets.index(of: snippet) else { return }
        story?.snippets[index].comments.insert(comment, at: 0)
        story?.update()
    }
    
    func setupCommentTextView() {
        commentTextView.layer.borderWidth = 2
        commentTextView.layer.borderColor = UIColor.black.cgColor
        commentTextView.layer.cornerRadius = 10
    }
    
    
}
