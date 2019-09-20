//
//  Water.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 9/5/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class Water {
    
    var generalKey: String?
    
    var day: Int?
    var month: Int?
    var year: Int?
    
    var waterCount: Double?
    
    convenience init(generalKey: String, dictionary: [String : AnyObject]) {
        self.init()
        
        self.generalKey = generalKey
        
        day = dictionary["day"] as? Int
        month = dictionary["month"] as? Int
        year = dictionary["year"] as? Int
        waterCount = dictionary["waterCount"] as? Double
    }
}

