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

enum StoryCategoryType: String {
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

enum SortByType: String {
    case name = "Name"
    case newest = "Newest"
    case oldest = "Oldest"
    case top = "Top"
    case featured = "Featured"
    case category = "Category"
}



