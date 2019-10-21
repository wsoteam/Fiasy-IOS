//
//  Promo.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 9/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class Promo {
    
    var generalKey: String?
    
    var activated: Bool?
    var duration: Int?
    var id: String?
    var type: Int?
    var userOwner: String?
    var valid: Bool = false
    var startActivated: Int?
    
    init(key: String, dictionary: [String : AnyObject]) {
        
        generalKey = key
        
        activated = dictionary["activated"] as? Bool
        duration = dictionary["duration"] as? Int
        id = dictionary["id"] as? String
        type = dictionary["type"] as? Int
        userOwner = dictionary["userOwner"] as? String
        valid = dictionary["valid"] as? Bool ?? false
        startActivated = dictionary["startActivated"] as? Int
    }
}
