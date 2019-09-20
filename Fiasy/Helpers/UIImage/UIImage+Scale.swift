//
//  UIImage+Scale.swift
//  onlinesadik
//
//  Created by Yuriy Sokirko on 12/25/18.
//  Copyright © 2018 Андрей. All rights reserved.
//

import UIKit
import AlamofireImage

extension UIImage {
    public func imageScaled(to size: CGSize) -> UIImage {
        assert(size.width > 0 && size.height > 0, "You cannot safely scale an image to a zero width or height")
        
        UIGraphicsBeginImageContextWithOptions(size, af_isOpaque, 0.0)
        draw(in: CGRect(origin: .zero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}
