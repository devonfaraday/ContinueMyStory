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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = stories[indexPath.row]
        selectedStory = story
        performSegue(withIdentifier: .toStoryDetailSegue, sender: self)
    }
   
    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? StoryViewController else { return }
        destination.story = selectedStory
    }
 

}
