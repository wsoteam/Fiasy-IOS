//
//  ActivityElement.swift
//  Fiasy
//
//  Created by Yuriy Sokirko on 9/15/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ActivityElement: Codable {
    
    var generalKey: String?
    
    var day: Int?
    var month: Int?
    var year: Int?
    var name: String?
    var count: Int?
    var time: Int?
    var calories: Int?
    var burned: Int?
    var addedTime: Int?
    var isFavorite: Bool?
    
    init(name: String?, count: Int?) {
        self.name = name
        self.addedTime = 0
        self.count = count
        self.time = 0
        self.calories = 0
        self.burned = 0
        self.isFavorite = false
    }
    
    init() {
        self.name = ""
        self.count = 0
        self.time = 0
        self.calories = 0
        self.burned = 0
        self.addedTime = 0
        self.isFavorite = false
    }
    
    init(generalKey: String, dictionary: [String : AnyObject]) {
        self.generalKey = generalKey
        
        count = 0
        day = dictionary["day"] as? Int
        month = dictionary["month"] as? Int
        year = dictionary["year"] as? Int
        addedTime = dictionary["added_time"] as? Int
        burned = dictionary["burned"] as? Int
        name = dictionary["title"] as? String
        time = dictionary["time"] as? Int
        isFavorite = dictionary["favorite"] as? Bool
        calories = dictionary["calories"] as? Int
    }
}

typealias Activity = [ActivityElement]
