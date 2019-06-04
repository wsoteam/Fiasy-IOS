//
//  MenuTabBarItem.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/26/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class MenuTabBarItem: UITabBarItem {
    
    @IBInspectable var imageItem: String? {
        didSet {
            guard let imageItem = imageItem else {
                return
            }
            
            image = UIImage.coloredImage(image: UIImage(named: imageItem), color: #colorLiteral(red: 0.3999532461, green: 0.4000268579, blue: 0.3999486566, alpha: 1))?.withRenderingMode(.alwaysOriginal)
            selectedImage = UIImage.coloredImage(image: UIImage(named: imageItem), color: #colorLiteral(red: 0.8755862713, green: 0.5467280149, blue: 0.1882739961, alpha: 1))?.withRenderingMode(.alwaysOriginal)
        }
    }
}
