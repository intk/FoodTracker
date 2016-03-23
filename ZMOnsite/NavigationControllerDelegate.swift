//
//  NavigationControllerDelegate.swift
//  ZMOnsite
//
//  Created by Andre Goncalves on 23/02/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    let transition = LayoutTransitionAnimator()
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let fromViewController = fromVC as? ObjectCollectionViewController
        let toViewController = toVC as? ObjectViewController
        
        if fromViewController != nil && toViewController != nil {
            return nil
        }
        
        let _fromViewController = fromVC as? ObjectViewController
        let _toViewController = toVC as? ObjectCollectionViewController
        
        if _fromViewController != nil && _toViewController != nil {
            return nil
        }
        
        return nil
    }
}
