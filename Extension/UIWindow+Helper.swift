//
//  UIWindow+Helper.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/24/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit

extension UIWindow {
  func currentViewController () -> UIViewController? {
    var viewController = self.rootViewController
    while viewController?.presentedViewController != nil {
      viewController = viewController?.presentedViewController
    }
    return viewController
  }
  
  func viewControllerForStatusBarStyle () ->UIViewController? {
    let currentViewController = self.currentViewController()
    if currentViewController?.childViewControllerForStatusBarStyle != nil {
      return currentViewController?.childViewControllerForStatusBarStyle
    }
    return currentViewController
  }
  
  func viewControllerForStatusBarHidden () ->UIViewController? {
    let currentViewController = self.currentViewController()
    if currentViewController?.childViewControllerForStatusBarHidden != nil {
      return currentViewController?.childViewControllerForStatusBarHidden
    }
    return currentViewController
  }
}
