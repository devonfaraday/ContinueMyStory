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
    
    
    /* Segues */
    static var toProfileViewControllerSegue: String { get { return "toProfileViewController" } }
    
    /* Story Keys */
    static var titleKey: String { get { return "title" } }
    static var bodyKey: String { get { return "body" } }
    static var authorKey: String { get { return "authorUid" } }
    static var commentsKey: String { get { return "comments" } }
    static var snippetKey: String { get { return "snippetIdentifiers" } }
    static var categoryKey: String { get { return "Category" } }
    
    /* User Firebase keys */
    static var usernameKey: String { get { return "username" } }
    static var givenNameKey: String { get { return "givenName" } }
    static var familyNameKey: String { get { return "familyName" } }
    static var ageKey: String { get { return "age" } }
    static var identifierKey: String { get { return "uid" } }
    

}
