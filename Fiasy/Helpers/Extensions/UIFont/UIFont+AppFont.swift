//
//  UIFont+AppFont.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/7/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func fontRobotoRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size)!
    }
    
    static func fontRobotoMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Medium", size: size)!
    }
    
    static func fontRobotoBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Bold", size: size)!
    }
    
    static func fontRobotoLight(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Light", size: size)!
    }
}

