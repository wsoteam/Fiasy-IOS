//
//  Mealtime.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/25/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class Mealtime {
    
    var generalKey: String?
    var parentKey: String?
    
    var day: Int?
    var month: Int?
    var year: Int?
    var name: String?
    var urlOfImages: String?
    var weight: Int?
    var protein: Int?
    var calories: Int?
    var fat: Int?
    var carbohydrates: Int?
    var presentDay: Bool = false

    init(parentKey: String, generalKey: String, dictionary: [String : AnyObject]) {
        self.parentKey = parentKey
        self.generalKey = generalKey

        day = dictionary["day"] as? Int
        month = dictionary["month"] as? Int
        year = dictionary["year"] as? Int
        name = dictionary["name"] as? String
        urlOfImages = dictionary["urlOfImages"] as? String
        weight = dictionary["weight"] as? Int
        protein = dictionary["protein"] as? Int
        calories = dictionary["calories"] as? Int
        fat = dictionary["fat"] as? Int
        carbohydrates = dictionary["carbohydrates"] as? Int
        presentDay = dictionary["presentDay"] as? Bool ?? false
    }
}
