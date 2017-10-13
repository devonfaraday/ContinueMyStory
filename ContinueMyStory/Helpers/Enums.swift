//
//  Enums.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/10/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import Foundation

enum LoginViewState {
    case login
    case signUp
}

enum ProfileViewState {
    case isEditing
    case isViewing
}

enum StoryCategory: String {
    case sifi = "SiFi"
    case fantasy = "Fantasy"
    case suspense = "Suspense"
}
