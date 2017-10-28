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
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        return dateFormatter.string(from: self)
    }
    
}
