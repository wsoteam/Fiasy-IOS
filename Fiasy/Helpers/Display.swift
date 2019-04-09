//
//  Display.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/7/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

public enum DisplayType {
    
    case unknown
    case iphone4
    case iphone5
    case iphone6
    case iphone6plus
    case iPadNonRetina
    case iPad
    case iPadProBig
    static let iphone7 = iphone6
    static let iphone7plus = iphone6plus
}

func isIphone5() -> Bool {
    if Display.typeIsLike == .iphone5 {
        return true
    } else { return false }
}

func isPad() -> Bool {
    
    if Display.pad == true {
        return true
    } else { return false }
}

public final class Display {
    
    class var width: CGFloat { return UIScreen.main.bounds.size.width }
    class var height: CGFloat { return UIScreen.main.bounds.size.height }
    class var maxLength: CGFloat { return max(width, height) }
    class var minLength: CGFloat { return min(width, height) }
    class var zoomed: Bool { return UIScreen.main.nativeScale >= UIScreen.main.scale }
    class var retina: Bool { return UIScreen.main.scale >= 2.0 }
    class var phone: Bool { return UIDevice.current.userInterfaceIdiom == .phone }
    class var pad: Bool { return UIDevice.current.userInterfaceIdiom == .pad }
    class var carplay: Bool { return UIDevice.current.userInterfaceIdiom == .carPlay }
    class var tv: Bool { return UIDevice.current.userInterfaceIdiom == .tv }
    
    static var padding: CGFloat = {
        if isIphone5() {
            return 15
        }
        if isPad() {
            //return 30
        }
        return 20
    }()
    
    static func isIphone5() -> Bool {
        if Display.typeIsLike == .iphone5 {
            return true
        } else {
            return false
        }
    }
    
    class var typeIsLike: DisplayType {
        if phone && maxLength < 568 {
            return .iphone4
        } else if phone && maxLength == 568 {
            return .iphone5
        } else if phone && maxLength == 667 {
            return .iphone6
        } else if phone && maxLength == 736 {
            return .iphone6plus
        } else if pad && !retina {
            return .iPadNonRetina
        } else if pad && retina && maxLength == 1024 {
            return .iPad
        } else if pad && maxLength == 1366 {
            return .iPadProBig
        }
        return .unknown
    }
}

// Helper, wrapper for Display.padding
func padding() -> CGFloat {
    return Display.padding
}


