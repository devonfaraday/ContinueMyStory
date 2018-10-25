//
//  StoryEntryContainerViewController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/16/18.
//  Copyright © 2018 Christian McMullin. All rights reserved.
//

import UIKit

class StoryEntryContainerViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var cmsLabel: UILabel!
    @IBOutlet var continueMyStoryButton: UIButton!
    @IBOutlet var entryBodyTextView: UITextView!
    
    var entryBody: String = ""
    var viewState: StoryEntryViewState = .story
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.black.cgColor
    }
    
    func updateViews() {
        updateEntryBodyTextView()
        updateForContinueMyStoryStateIfNeeded()
    }
    
    func updateEntryBodyTextView() {
        entryBodyTextView.text = entryBody
        entryBodyTextView.isHidden = viewState == .continueMyStory
        entryBodyTextView.isEditable = false
        entryBodyTextView.isSelectable = false
    }
    
    func updateForContinueMyStoryStateIfNeeded() {
            cmsLabel.isHidden = viewState != .continueMyStory
            continueMyStoryButton.isHidden = viewState != .continueMyStory
    }
    
    @IBAction func continueMyStoryButtonTapped(_ sender: Any) {
        
    }
    
    func updateViewsForAddingEntry() {
        entryBodyTextView.isSelectable = true
        entryBodyTextView.isEditable = true
        entryBodyTextView.becomeFirstResponder()
    }
}
