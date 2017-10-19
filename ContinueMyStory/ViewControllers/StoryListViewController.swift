//
//  StoryListViewController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/12/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import UIKit

class StoryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var stories = [Story]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    var selectedStory: Story?
    var snippets = [Snippet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StoryController().fetchAllStories { (stories) in
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
        SnippetController().fetchSnippets(fromStory: story) { (snippets) in
            self.snippets = snippets
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: .toStoryDetailSegue, sender: self)
            }
        }
        
    }
    @IBAction func backButtonTapped(_ sender: UIButton) {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? StoryViewController else { return }
        destination.story = selectedStory
    }
 

}
