//
//  UIImage+CMS.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 6/23/18.
//  Copyright © 2018 Christian McMullin. All rights reserved.
//

import UIKit

extension UIImage {
    
    func convertToData() -> Data? {
        return UIImageJPEGRepresentation(self, 1.0)
    }
}
