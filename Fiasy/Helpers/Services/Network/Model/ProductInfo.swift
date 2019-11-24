//
//  ProductInfo.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/4/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import ObjectMapper

class ProductInfo: NSObject, Mappable {
    
    var name: String?
    var index: String?
    var type: String?
    var id: String?
    var score: Int?
    //var source: ProductDetails?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        //id <- map["_id"]
        name <- map["text"]
//        index <- map["_index"]
//        type <- map["_type"]
//        score <- map["_score"]
        //source <- map["_source"]
    }
}
