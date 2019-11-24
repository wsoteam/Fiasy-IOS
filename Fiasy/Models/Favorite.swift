//
//  Favorite.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/16/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class Favorite {
    
    var key: String?
    var name: String?
    var brand: String?
    var calories: Double?
    var proteins: Double?
    var carbohydrates: Double?
    var sugar: Double?
    var fats: Double?
    var saturatedFats: Double?
    var monoUnSaturatedFats: Double?
    var polyUnSaturatedFats: Double?
    var cholesterol: Double?
    var cellulose: Double?
    var sodium: Double?
    var pottassium: Double?
    var barcode: String?
    var isLiquid: Bool?
    var measurementUnits: [MeasurementUnits] = []

    init(dictionary: [String : AnyObject], generalKey: String) {
        
        key = generalKey
        barcode = dictionary["barcode"] as? String
        name = dictionary["name"] as? String
        brand = dictionary["brand"] as? String
        calories = dictionary["calories"] as? Double
        proteins = dictionary["proteins"] as? Double
        carbohydrates = dictionary["carbohydrates"] as? Double
        sugar = dictionary["sugar"] as? Double
        fats = dictionary["fats"] as? Double
        saturatedFats = dictionary["saturatedFats"] as? Double
        monoUnSaturatedFats = dictionary["monoUnSaturatedFats"] as? Double
        polyUnSaturatedFats = dictionary["polyUnSaturatedFats"] as? Double
        cholesterol = dictionary["cholesterol"] as? Double
        cellulose = dictionary["cellulose"] as? Double
        sodium = dictionary["sodium"] as? Double
        pottassium = dictionary["pottassium"] as? Double
        isLiquid = dictionary["is_Liquid"] as? Bool
        
        if let list = dictionary["measurement_units"] as? [NSDictionary] {
            for item in list {
                let measurement: MeasurementUnits = MeasurementUnits()
                measurement.name = item["name"] as? String
                if let text = item["amount"] as? String, let count = Int(text) {
                    measurement.amount = count
                }
                measurement.unit = item["unit"] as? String ?? ""
                measurementUnits.append(measurement)
            }
        }
    }
}
