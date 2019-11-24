//
//  Suggest.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/4/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import ObjectMapper

class Suggest: NSObject, Mappable {
    
    var list: [PaginationProduct] = []
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        list <- map["name_suggest__completion"]
    }
}
