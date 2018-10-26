//
//  StoryPageViewController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/13/18.
//  Copyright © 2018 Christian McMullin. All rights reserved.
//

import UIKit

class StoryPageViewController: UIPageViewController {
    
    var currentPage: Int = 1 {
        didSet {
            storyDelegate?.storyPageDidTurn(toPageNumber: currentPage)
        }
    }
    var maxPageCount: Int {
        guard let story = self.story else { return 0 }
        return story.snippets.count + 2
    }
    var orderedViewControllers: [UIViewController] = []
    weak var storyDelegate: StoryDelegate?
    var story: Story?

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
        guard let story = story else { return }
        let storyVC: StoryEntryContainerViewController = instantiateStoryEntryViewController()
        storyVC.pageNumber = 1
        storyVC.entryBody = story.body
        storyVC.author = story.author
        storyVC.viewState = .story
        orderedViewControllers.append(storyVC)
    }
    
    func addSnippetToViewControllers() {
        var snippetControllers: [StoryEntryContainerViewController] = []
        guard let story = story
        else { return }
        for snippet in story.snippets {
            guard let index = story.snippets.index(of: snippet) else { return }
            let snippetVC: StoryEntryContainerViewController = instantiateStoryEntryViewController()
            snippetVC.pageNumber = index + 2
            snippetVC.author = snippet.author
            snippetVC.entryBody = snippet.body
            snippetVC.viewState = .snippet
            snippetControllers.append(snippetVC)
        }
        orderedViewControllers.append(contentsOf: snippetControllers)
    }
    
    func appendContinueMyStoryViewToOrderedViewControllers() {
        let continueMyStoryView: StoryEntryContainerViewController = instantiateStoryEntryViewController()
        continueMyStoryView.pageNumber = maxPageCount
        continueMyStoryView.entryBody = ""
        continueMyStoryView.viewState = .continueMyStory
        orderedViewControllers.append(continueMyStoryView)
    }
    
    func instantiateStoryEntryViewController() -> StoryEntryContainerViewController {
        guard let storyEntryViewController = instantiateViewController(withName: "Story", andIdentifier: "StoryEntryContainerViewController") as? StoryEntryContainerViewController else { return StoryEntryContainerViewController() }
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
        guard viewControllerIndex != 0 else {
            return nil
        }
        currentPage = viewControllerIndex
        let previousIndex = viewControllerIndex - 1
        guard previousIndex > 0 else {
            currentPage = 1
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
        currentPage = viewControllerIndex + 2
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        guard orderedViewControllersCount != nextIndex else {
            currentPage = 1
            return orderedViewControllers.first
        }
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return orderedViewControllers[nextIndex]    }
}

protocol StoryDelegate: class {
    func storyPageDidTurn(toPageNumber pageNumber: Int)
}
