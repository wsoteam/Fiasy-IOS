//
//  UIImage+URL.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/19/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import Kingfisher

extension UIImageView {
    
    func setImage(with urlString: String){
        guard let url = URL.init(string: urlString) else {
            return
        }
        let resource = ImageResource(downloadURL: url, cacheKey: urlString)
        var kf = self.kf
        kf.indicatorType = .activity
        self.kf.setImage(with: resource)
    }
}
