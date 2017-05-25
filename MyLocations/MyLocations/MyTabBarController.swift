//
//  MyTabBarController.swift
//  MyLocations
//
//  Created by Norman Lopez on 5/22/17.
//  Copyright © 2017 Norman Lopez. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override var childViewControllerForStatusBarStyle: UIViewController? {
        return nil
    }
}
