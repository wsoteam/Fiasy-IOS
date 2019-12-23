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
            
            image = UIImage.coloredImage(image: UIImage(named: imageItem), color: #colorLiteral(red: 0.6821901202, green: 0.7011104226, blue: 0.7552901506, alpha: 1))?.withRenderingMode(.alwaysOriginal)
            selectedImage = UIImage.coloredImage(image: UIImage(named: imageItem), color: #colorLiteral(red: 0.8755862713, green: 0.5467280149, blue: 0.1882739961, alpha: 1))?.withRenderingMode(.alwaysOriginal)
            
            switch title {
            case "Дневник":
                title = LS(key: .TAB_TITLE1)
            case "Статьи":
                title = LS(key: .TAB_TITLE2)
            case "Рецепты":
                title = LS(key: .TAB_TITLE3)
            case "Профиль":
                title = LS(key: .TAB_TITLE4)
            default:
                break
            }
        }
    }
}
