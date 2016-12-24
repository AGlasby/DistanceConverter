//
//  FadInAnimator.swift
//  DistanceConverter
//
//  Created by Alan Glasby on 18/12/2016.
//  Copyright © 2016 Alan Glasby. All rights reserved.
//

import UIKit

class AFGFadeInAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        containerView.addSubview(toVC!.view)
        toVC!.view.alpha = 0.0
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {toVC!.view.alpha = 1.0}, completion: {finished in
            let cancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!cancelled)
        })
    }
}
