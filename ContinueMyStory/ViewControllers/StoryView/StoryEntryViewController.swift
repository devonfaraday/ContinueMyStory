//
//  StoryEntryViewController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/13/18.
//  Copyright © 2018 Christian McMullin. All rights reserved.
//

import UIKit

class StoryEntryViewController: UIViewController {

    @IBOutlet var storyContainerView: UIView!
    
    var author: User?
    var currentPageNumber: Int = 1
    var maxPageNumber: Int {
        guard let story = story else { return 0 }
        return story.snippets.count + 2
    }
    var snippet: Snippet?
    var story: Story?
    var viewState: StoryEntryViewState = .story
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StoryPageViewController" {
            guard let storyPageViewController = segue.destination as? StoryPageViewController else { return }
            storyPageViewController.story = story
        }
    }
}

enum StoryEntryViewState {
    case story
    case snippet
    case continueMyStory
}
