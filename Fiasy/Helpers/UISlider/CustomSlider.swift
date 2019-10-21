//
//  CustomSlider.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 9/12/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class CustomSlider: UISlider {
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let size = CGSize(width: bounds.size.width, height: 8.0)
        let customBounds = CGRect(origin: bounds.origin, size: size)
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let size = CGSize(width: 30, height: 30)
        self.setThumbImage(#imageLiteral(resourceName: "thumb").imageScaled(to: size), for: .normal)
    }
    
}
//
//class SecondCustomSlider: UISlider {
//
//    override func trackRect(forBounds bounds: CGRect) -> CGRect {
//        let size = CGSize(width: bounds.size.width, height: 6.0)
//        let customBounds = CGRect(origin: bounds.origin, size: size)
//        super.trackRect(forBounds: customBounds)
//        return customBounds
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        let size = CGSize(width: 20, height: 20)
//        self.setThumbImage(#imageLiteral(resourceName: "Без имени-1").imageScaled(to: size), for: .normal)
//    }
//
//}

