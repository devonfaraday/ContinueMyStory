//
//  StoryViewController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/11/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var storyTitleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var story: Story?  {
        didSet {
            if !isViewLoaded {
                loadViewIfNeeded()
            } else {
                storyTitleLabel.text = story?.title
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: .storyCellIdentifier, for: indexPath) as? StoryTableViewCell else { return StoryTableViewCell() }
        guard let story = story else { return StoryTableViewCell() }
        cell.story = story
        return cell
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
