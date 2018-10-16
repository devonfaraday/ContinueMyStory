//
//  StoryPageViewController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/13/18.
//  Copyright © 2018 Christian McMullin. All rights reserved.
//

import UIKit

class StoryPageViewController: UIPageViewController {
    
    var orderedViewControllers: [UIViewController] = []
    var story: Story?
    var maxPageCount: Int {
        guard let story = self.story else { return 0 }
        return story.snippets.count + 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStory()
        dataSource = self
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func setupStory() {
        addStoryToViewControllers()
        addSnippetToViewControllers()
        appendContinueMyStoryViewToOrderedViewControllers()
    }
    
    func addStoryToViewControllers() {
        let storyVC: StoryEntryViewController = instantiateStoryEntryViewController()
        storyVC.story = story
        storyVC.currentPageNumber = 1
        storyVC.maxPageNumber = maxPageCount
        storyVC.viewState = .story
        orderedViewControllers.append(storyVC)
    }
    
    func addSnippetToViewControllers() {
        var snippetControllers: [StoryEntryViewController] = []
        guard let story = story
        else { return }
        for snippet in story.snippets {
            guard let index = story.snippets.index(of: snippet) else { return }
            let snippetVC: StoryEntryViewController = instantiateStoryEntryViewController()
            snippetVC.snippet = snippet
            snippetVC.currentPageNumber = index + 2
            snippetVC.maxPageNumber = maxPageCount
            snippetVC.viewState = .snippet
            snippetControllers.append(snippetVC)
        }
        orderedViewControllers.append(contentsOf: snippetControllers)
    }
    
    func appendContinueMyStoryViewToOrderedViewControllers() {
        let continueMyStoryView: StoryEntryViewController = instantiateStoryEntryViewController()
        continueMyStoryView.story = story
        continueMyStoryView.viewState = .continueMyStory
        orderedViewControllers.append(continueMyStoryView)
    }
    
    func instantiateStoryEntryViewController() -> StoryEntryViewController {
        guard let storyEntryViewController = instantiateViewController(withName: "Story", andIdentifier: "StoryEntryViewController") as? StoryEntryViewController else { return StoryEntryViewController() }
        return storyEntryViewController
    }
    
    func instantiateViewController(withName name: String, andIdentifier identifier: String) -> UIViewController {
        return UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension StoryPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else { return nil }
        var previousIndex = viewControllerIndex - 1
        if previousIndex < 0 {
            previousIndex = orderedViewControllers.count - 1
        }
        guard previousIndex >= 0 else {
            return orderedViewControllers.first
        }
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
        }
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return orderedViewControllers[nextIndex]    }
}
