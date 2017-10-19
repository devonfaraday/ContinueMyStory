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
    case none = "---"
    case crime = "Crime"
    case fable = "Fable"
    case fanFiction = "Fan Fiction"
    case fantasy = "Fantasy"
    case folklore = "Folklore"
    case historicalFiction = "Historical Fiction"
    case horror = "Horror"
    case legend = "Legend"
    case mystery = "Mystery"
    case mythology = "Mythology"
    case romance = "Romance"
    case sifi = "SiFi"
    case shortStory = "ShortStory"
    case suspense = "Suspense"
    case tallTale = "Tall Tale"
    case western = "Western"
}



