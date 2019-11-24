//
//  MeasurementUnits.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/14/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import ObjectMapper

class MeasurementUnits: NSObject, Mappable {
    
    var id: Int?
    var name: String?
    var amount: Int = 0
    var unit: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        amount <- map["amount"]
        unit <- map["unit"]
    }
}
