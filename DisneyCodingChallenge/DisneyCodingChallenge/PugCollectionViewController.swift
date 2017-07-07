//
//  PugCollectionViewController.swift
//  DisneyCodingChallenge
//
//  Created by Wellington Moreno on 7/7/17.
//  Copyright © 2017 Disney, Inc. All rights reserved.
//

import Foundation
import UIKit

class PugCollectionViewController: UICollectionViewController {
    
    fileprivate var images = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: Collection View Data Source Methods
extension PugCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
