//
//  ProductDetails.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/4/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import ObjectMapper

class ProductDetails: NSObject, Mappable {
    
    var portion: Int?
    var calories: Double?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        portion <- map["portion"]
        calories <- map["calories"]
    }
}
