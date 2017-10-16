//
//  Date+CMS.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/15/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import Foundation

extension Date {
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
}
