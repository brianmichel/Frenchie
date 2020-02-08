//
//  UIViewController+Helpers.swift
//  Frenchie
//
//  Created by Brian Michel on 2/8/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import UIKit

extension UIViewController {
    func addChildViewControllerCompletely(_ childViewController: UIViewController?, belowSubview subview: UIView? = nil, withParentView parentView: UIView? = nil) {
        guard let childViewController = childViewController else { return }
        
        childViewController.willMove(toParent: self)
        addChild(childViewController)
        
        guard let parentView = parentView ?? view else { return }
        
        if let subview = subview {
            parentView.insertSubview(childViewController.view, belowSubview: subview)
        } else {
            parentView.addSubview(childViewController.view)
        }
        
        childViewController.didMove(toParent: self)
    }
    
    func removeChildViewControllerCompletely(_ childViewController: UIViewController?) {
        guard let childViewController = childViewController else { return }
        childViewController.willMove(toParent: nil)
        childViewController.removeFromParent()
        childViewController.view.removeFromSuperview()
        childViewController.didMove(toParent: nil)
    }
    
    func removeFromParentViewControllerCompletely() {
        guard parent != nil else { return }
        self.willMove(toParent: nil)
        self.removeFromParent()
        self.view.removeFromSuperview()
        self.didMove(toParent: nil)
    }
}
