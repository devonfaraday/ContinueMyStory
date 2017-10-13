//
//  Dictionary+CMS.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/12/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import Foundation

extension Dictionary {
    
        func removingValue(forKey key: Key) -> [Key: Value] {
            var mutableDictionary = self
            mutableDictionary.removeValue(forKey: key)
            return mutableDictionary
        }
    
}
