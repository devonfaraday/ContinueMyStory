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
    
    /* User Firebase keys */
    static var usernameKey: String { get { return "username" } }
    static var emailKey: String { get { return "email" } }
    static var givenNameKey: String { get { return "givenName" } }
    static var familyNameKey: String { get { return "familyName" } }
    static var ageKey: String { get { return "age" } }
    static var identifierKey: String { get { return "uid" } }

}
