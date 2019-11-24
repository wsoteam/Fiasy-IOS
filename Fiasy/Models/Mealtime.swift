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
    var protein: Double?
    var calories: Double?
    var fat: Double?
    var carbohydrates: Double?
    var presentDay: Bool = false
    var measurementUnits: [MeasurementUnits] = []
    
    // MARK: - Second -
    var productId: Int?
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
    var isRecipe: Bool?
    var isLiquid: Bool?
    var selectedUnit: String?
    var portionId: Int?

    init(parentKey: String, generalKey: String, dictionary: [String : AnyObject]) {
        self.parentKey = parentKey
        self.generalKey = generalKey

        productId = dictionary["product_id"] as? Int
        day = dictionary["day"] as? Int
        month = dictionary["month"] as? Int
        year = dictionary["year"] as? Int
        name = dictionary["name"] as? String
        urlOfImages = dictionary["urlOfImages"] as? String
        weight = dictionary["weight"] as? Int
        protein = dictionary["protein"] as? Double
        calories = dictionary["calories"] as? Double
        fat = dictionary["fat"] as? Double
        carbohydrates = dictionary["carbohydrates"] as? Double
        presentDay = dictionary["presentDay"] as? Bool ?? false
        isRecipe = dictionary["isRecipe"] as? Bool ?? false
        fats = dictionary["fats"] as? Double
        secondCarbohydrates = dictionary["carbohydrates"] as? Double
        cholesterol = dictionary["cholesterol"] as? Double
        polyUnSaturatedFats = dictionary["polyUnSaturatedFats"] as? Double
        sodium = dictionary["sodium"] as? Double
        cellulose = dictionary["cellulose"] as? Double
        proteins = dictionary["proteins"] as? Double
        brand = dictionary["brand"] as? String
        saturatedFats = dictionary["saturatedFats"] as? Double
        monoUnSaturatedFats = dictionary["monoUnSaturatedFats"] as? Double
        pottassium = dictionary["pottassium"] as? Double
        sugar = dictionary["sugar"] as? Double
        secondCalories = dictionary["calories"] as? Double
        selectedUnit = dictionary["selectedUnit"] as? String
        isLiquid = dictionary["is_Liquid"] as? Bool
        portionId = dictionary["portionId"] as? Int

        if let list = dictionary["measurement_units"] as? [NSDictionary] {
            for item in list {
                let measurement: MeasurementUnits = MeasurementUnits()
                measurement.name = item["name"] as? String
                if let text = item["amount"] as? String, let count = Int(text) {
                    measurement.amount = count
                }
                if let id = item["id"] as? Int {
                    measurement.id = id
                }
                measurement.unit = item["unit"] as? String ?? ""
                measurementUnits.append(measurement)
            }
        }
    }
}
