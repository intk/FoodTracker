//
//  ObjectCollectionView.swift
//  ZMOnsite
//
//  Created by Andre Goncalves on 25/02/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class ObjectCollectionView: UICollectionView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var inactiveTimer: NSTimer!
    let inactiveLimit: NSTimeInterval = 60.0
    var navigationController: UINavigationController!
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent:event)
        inactiveTimer.invalidate()
        inactiveTimer = NSTimer.scheduledTimerWithTimeInterval(inactiveLimit, target: self, selector: Selector("dismissViewController"), userInfo: nil, repeats: false)
    }
    
    func initTimer() {
        inactiveTimer = NSTimer.scheduledTimerWithTimeInterval(inactiveLimit, target: self, selector: Selector("dismissViewController"), userInfo: nil, repeats: false)
    }
    
    func dismissViewController() {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func invalidateTimer() {
        inactiveTimer.invalidate()
    }
}
