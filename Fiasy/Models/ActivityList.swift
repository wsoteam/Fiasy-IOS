//
//  ActivityList.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 9/15/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ActivityList: Codable {
    
    let name: String?
    let time: Int?
    let calories: Int?
    
    init(dictionary: [String : AnyObject]) {
        
        name = dictionary["title"] as? String
        time = dictionary["time"] as? Int
        calories = dictionary["calories"] as? Int
    }
}
