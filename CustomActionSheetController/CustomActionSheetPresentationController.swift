//
//  CustomActionSheetPresentationController.swift
//
//  Created by ToKoRo on 2015-01-19.
//

import UIKit

class CustomActionSheetPresentationController: UIPresentationController {

    weak var dimmingView: UIView?
    
    override func presentationTransitionWillBegin() {
        let containerView = self.containerView
        let dimmingView = UIView(frame: containerView.bounds)
        dimmingView.backgroundColor = UIColor.blackColor()
        dimmingView.alpha = 0.0
        containerView.insertSubview(dimmingView, atIndex: 0)
         
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ _ in
            dimmingView.alpha = 0.5
        }, completion: nil)

        self.dimmingView = dimmingView
    }
     
    override func dismissalTransitionWillBegin() {
        if let dimmingView = self.dimmingView {
            self.presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ _ in
                dimmingView.alpha = 0.0
            }, completion: nil)
        }
    }
     
    override func dismissalTransitionDidEnd(completed: Bool) {
        if completed {
            self.dimmingView?.removeFromSuperview()
        }
    }
     
    override func containerViewDidLayoutSubviews() {
        self.dimmingView?.frame = self.containerView.bounds
    }

}
