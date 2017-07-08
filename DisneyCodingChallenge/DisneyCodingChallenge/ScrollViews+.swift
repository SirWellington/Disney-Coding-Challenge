//
//  ScrollViews+.swift
//  DisneyCodingChallenge
//
//  Created by Wellington Moreno on 7/7/17.
//  Copyright © 2017 Disney, Inc. All rights reserved.
//

import Foundation
import UIKit



extension UIScrollView {
    
    var atTheBottom: Bool {
        
        let bottomEdge = self.contentOffset.y + self.frame.size.height
        return bottomEdge >= contentSize.height
    }
}
