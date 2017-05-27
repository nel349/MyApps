//
//  DimmingPresentationController.swift
//  StoreSearch
//
//  Created by Norman Lopez on 5/26/17.
//  Copyright © 2017 Norman Lopez. All rights reserved.
//

import UIKit
class DimmingPresentationController: UIPresentationController {
    
    lazy var dimmingView = GradientView(frame: CGRect.zero)
    
    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView!.bounds
        containerView!.insertSubview(dimmingView, at: 0)
    }
    
    override var shouldRemovePresentersView: Bool {
        return false
    }
}
