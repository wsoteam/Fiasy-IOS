//
//  UIApplication+GetTopViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/3/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

extension UIApplication {
    class func getTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopMostViewController(base: selected)
            }
        }
        
        if let nav = base as? UINavigationController {
            return getTopMostViewController(base: nav.visibleViewController)
        }
        if let presented = base?.presentedViewController {
            return getTopMostViewController(base: presented)
        }
        return base
    }
}
