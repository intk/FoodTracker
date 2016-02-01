//
//  RoundedCornersView.swift
//  FoodTracker
//
//  Created by Andre Goncalves on 27/01/16.
//  Copyright © 2016 INTK. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedCornersView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = 0
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
}
