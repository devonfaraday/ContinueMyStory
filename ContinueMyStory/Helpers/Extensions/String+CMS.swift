//
//  String+CMS.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/10/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import Foundation

extension String {
    
    /* Firebase Endpoints */
    static var usersEndpoint: String { get { return "users" } }
    static var storiesEndpoint: String { get { return "stories" } }
    static var categoryEndpoint: String { get { return "category" } }
    
    /* Firebase Storage */
    static var profileImagesKey: String { get { return "profileImages" } }
    static var imagesKey: String { get { return "images" } }
    
    /* Reuse Identifiers */
    static var commentCellIdentifier: String { get { return "commentCell" } }
    static var profileCellIdentifier: String { get { return "profileCell" } }
    static var snippetCellIdentifier: String { get { return "snippetCell" } }
    static var sortyByCellIdentifier: String { get { return "sortByCell" } }
    static var storyCellIdentifier: String { get { return "storyCell" } }
    static var storyListCellIdentifier: String { get { return "storyListCell" } }
    
    /* Segues */
    static var toBioViewControllerSegue: String { get { return "toBioViewController" } }
    static var toProfileFeedEmbededSegueKey: String { get { return "toProfileFeed" } }
    static var toProfileViewControllerSegue: String { get { return "toProfileViewController" } }
    static var toStoryDetailSegue: String { get { return "toStoryDetail" } }
    static var toStoryListSegue: String { get { return "toStoryList" } }
    static var toLoginViewControllerSegue: String { get { return "toLoginViewController" } }
    static var toSortByViewControllerSegue: String { get { return "toSortByViewController" } }
    static var toCommentViewControllerSegue: String { get { return "toCommentViewController" } }
    
    /* Story Keys */
    static var titleKey: String { get { return "title" } }
    static var bodyKey: String { get { return "body" } }
    static var authorKey: String { get { return "authorUid" } }
    static var commentsKey: String { get { return "comments" } }
    static var snippetIdentifierKey: String { get { return "snippetIdentifiers" } }
    static var categoryKey: String { get { return "category" } }
    static var snippetKey: String { get { return "snippets" } }
    static var storyReferenceKey: String { get { return "storyReference" } }
    static var snippetReferenceKey: String { get { return "snippetReference" } }
    static var createdKey: String { get { return "created" } }
    static var likesKey: String { get { return "likes" } }
    
    
    /* User Firebase keys */
    static var usernameKey: String { get { return "username" } }
    static var givenNameKey: String { get { return "givenName" } }
    static var familyNameKey: String { get { return "familyName" } }
    static var ageKey: String { get { return "age" } }
    static var identifierKey: String { get { return "uid" } }
    static var storyFollowingKey: String { get { return "storiesFollowing" } }
    static var followingKey: String { get { return "following" } }
    static var followersKey: String { get { return "followers" } }
    
    // MARK: - Functions
    func date() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        guard let date = formatter.date(from: self) else { return nil }
        return date
    }
}
