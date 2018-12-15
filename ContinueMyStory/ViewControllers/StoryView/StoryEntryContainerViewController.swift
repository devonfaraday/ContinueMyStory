//
//  StoryEntryContainerViewController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/16/18.
//  Copyright © 2018 Christian McMullin. All rights reserved.
//

import UIKit

class StoryEntryContainerViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var cmsLabel: UILabel!
    @IBOutlet var continueMyStoryButton: UIButton!
    @IBOutlet var commentButton: UIButton!
    @IBOutlet var entryBodyTextView: UITextView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var pageNumberLabel: UILabel!
    @IBOutlet var profileImageButton: UIButton!
    
    var author: User?
    var entryBody: String = ""
    var pageNumber: Int = 1
    var viewState: StoryEntryViewState = .story
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.black.cgColor
    }
    
    func fetchProfileImage() {
        let imageController = ImageController()
        DispatchQueue.global().async {
            imageController.fetchImage(forUser: self.author) { (image) in
                DispatchQueue.main.async {
                    self.profileImageButton.setBackgroundImage(image, for: .normal)
                    self.profileImageButton.setTitle("", for: .normal)
                }
            }
        }
    }
    
    func layoutProfileImageButton() {
        self.profileImageButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.09915453767)
        self.profileImageButton.layer.borderWidth = -2
        self.profileImageButton.layer.cornerRadius = self.profileImageButton.frame.width / 2
        self.profileImageButton.imageView?.layer.cornerRadius = self.profileImageButton.frame.width / 2
    }
    
    func updateViews() {
        layoutProfileImageButton()
        fetchProfileImage()
        updatePageNumber()
        updateEntryBodyTextView()
        updateForContinueMyStoryStateIfNeeded()
        updateAuthorInfo()
    }
    
    func updatePageNumber() {
        pageNumberLabel.text = "\(pageNumber)"
    }
    
    func updateAuthorInfo() {
        guard let author: User = self.author
            else { return }
        authorLabel.text = author.fullName
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
        authorLabel.isHidden = viewState == .continueMyStory
        likeButton.isHidden = viewState == .continueMyStory
        commentButton.isHidden = viewState == .continueMyStory
        profileImageButton.isHidden = viewState == .continueMyStory
    }
    
    @IBAction func continueMyStoryButtonTapped(_ sender: Any) {
        continueMyStoryButton.isHidden = true
        
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func commentButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func profileImageButtonTapped(_ sender: Any) {
        
    }
    
    func updateViewsForAddingEntry() {
        entryBodyTextView.isSelectable = true
        entryBodyTextView.isEditable = true
        entryBodyTextView.becomeFirstResponder()
    }
}
