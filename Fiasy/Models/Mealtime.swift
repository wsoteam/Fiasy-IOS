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
    
    // MARK: - Second -
    var fats: Double?
    var secondCarbohydrates: Double?
    var cholesterol: Double?
    var polyUnSaturatedFats: Double?
    var sodium: Double?
    var cellulose: Double?
    var proteins: Double?
    var brand: String?
    var saturatedFats: Double?
    var monoUnSaturatedFats: Double?
    var pottassium: Double?
    var sugar: Double?
    var secondCalories: Double?

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
        
        fats = dictionary["fats"] as? Double
        secondCarbohydrates = dictionary["carbohydrates"] as? Double
        cholesterol = dictionary["cholesterol"] as? Double
        polyUnSaturatedFats = dictionary["polyUnSaturatedFats"] as? Double
        sodium = dictionary["sodium"] as? Double
        cellulose = dictionary["cellulose"] as? Double
        proteins = dictionary["proteins"] as? Double
        brand = dictionary["brand"] as? String
        saturatedFats = dictionary["saturatedFats"] as? Double
        monoUnSaturatedFats = dictionary["saturatedFats"] as? Double
        pottassium = dictionary["pottassium"] as? Double
        sugar = dictionary["sugar"] as? Double
        secondCalories = dictionary["calories"] as? Double
    }
}
