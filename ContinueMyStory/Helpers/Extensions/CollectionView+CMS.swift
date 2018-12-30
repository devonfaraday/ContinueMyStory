//
//  CollectionView+CMS.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 5/20/18.
//  Copyright © 2018 Christian McMullin. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func reloadDataOnMainQueue() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
