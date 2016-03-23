//
//  LayoutTransitionAnimator.swift
//  ZMOnsite
//
//  Created by Andre Goncalves on 23/02/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class LayoutTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    weak var transitionContext: UIViewControllerContextTransitioning?
    var presenting = true
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        
        let fromVC = transitionContext.viewControllerForKey(
            UITransitionContextFromViewControllerKey)
        
        let toVC = transitionContext.viewControllerForKey(
            UITransitionContextToViewControllerKey)

        containerView!.addSubview(toVC!.view)
        
        toVC!.view.alpha = 0.0

        let duration = transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, animations: {
            fromVC!.view.alpha = 1.0
            }, completion: { finished in
                UIView.animateWithDuration(duration, animations: {
                    toVC!.view.alpha = 1.0
                    }, completion: { finished in
                        let cancelled = transitionContext.transitionWasCancelled()
                        transitionContext.completeTransition(!cancelled)
                })
        })
    }
}
