//
//  StoryListViewController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/12/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import UIKit

class StoryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SortTypeSelectable{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var sortButton: UIButton!
    @IBOutlet var containerView: UIView!
    
    var stories = [Story]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    var selectedStory: Story?
    var snippets = [Snippet]()
    // TODO: - Figure out how to fetch comments for snippets
    override func viewDidLoad() {
        super.viewDidLoad()
        hideSortByOptions()
        StoryController().fetchAllStories { (stories) in
            for story in stories {
                DispatchQueue.global().async {
                CommentController().fetchComments(fromStory: story, completion: { (comments) in
                    story.comments = comments
                })
                }
        
            }
            self.stories = stories
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .storyListCellIdentifier, for: indexPath)
        let story = stories[indexPath.row]
        cell.textLabel?.text = story.title
        UserController().fetchUser(withIdentifier: story.author) { (user) in
            guard let user = user else { return }
            cell.detailTextLabel?.text = "By: \(user.username)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = stories[indexPath.row]
        selectedStory = story
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: .toStoryDetailSegue, sender: self)
            }
        
        
    }
    
    func sortByFinished(withValue value: SortByType) {
        sortButton.setTitle(value.rawValue, for: .normal)
        hideSortByOptions()
    }
    
    @IBAction func sortButtonTapped(_ sender: UIButton) {
        showSortByOptions()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func showSortByOptions() {
        UIView.animate(withDuration: 0.3) {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: 0.1)
        }
    }
    
    func hideSortByOptions() {
        UIView.animate(withDuration: 0.3) {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: -self.containerView.frame.height)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == String.toSortByViewControllerSegue {
            guard let destination = segue.destination as? SortByViewController else { return }
            destination.delegate = self
        }
        if segue.identifier == String.toStoryDetailSegue {
            guard let destination = segue.destination as? StoryPageViewController else { return }
            destination.story = selectedStory
        }
    }
}
