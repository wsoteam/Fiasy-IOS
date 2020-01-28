//
//  Product.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/22/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import SQLite
import ObjectMapper

class Product: NSObject {

    var id: Int?
    var day: Int?
    var month: Int?
    var year: Int?
    var name: String?
    var brend: String?
    var portion: Double?
    var isLiquid: Bool?
    var kilojoules: Double?
    var calories: Double?
    var proteins: Double?
    var carbohydrates: Double?
    var generalKey: String?
    var sugar: Double?
    var fats: Double?
    var weight: Int?
    var saturatedFats: Double?
    var monoUnSaturatedFats: Double?
    var polyUnSaturatedFats: Double?
    var cholesterol: Double?
    var cellulose: Double?
    var sodium: Double?
    var pottassium: Double?
    var presentDay: Bool = false
    var isRecipe: Bool = false
    var isMineProduct: Bool = false
    
    var parentKey: String?
    var measurementUnits: [MeasurementUnits] = []
    var selectedPortion: MeasurementUnits?
    var selectedUnit: String?
    var portionId: Int?
    var divisionBasketTitle: String?

    var productWeightByAdd: Int?

    var percentCarbohydrates: Int?
    var percentFats: Int?
    var percentProteins: Int?
    var generalFindId: String?

    required convenience init(row: Row) {
        self.init()

        id = row[Expression<Int>("ID")]
        name = row[Expression<String>("NAME")].replacingOccurrences(of: "\"", with: "")
        brend = row[Expression<String>("BREND")]
        portion = row[Expression<Double>("PORTION")]
        isLiquid = row[Expression<Bool>("IS_LIQUID")]
        kilojoules = row[Expression<Double>("KILOJOULES")]
        calories = row[Expression<Double>("CALORIES")]
        proteins = row[Expression<Double>("PROTEINS")]
        carbohydrates = row[Expression<Double>("CARBOHYDRATES")]
        sugar = row[Expression<Double>("SUGAR")]
        fats = row[Expression<Double>("FATS")]
        saturatedFats = row[Expression<Double>("SATURATED_FATS")]
        monoUnSaturatedFats = row[Expression<Double>("MONO_UN_SATURATED_FATS")]
        polyUnSaturatedFats = row[Expression<Double>("POLY_UN_SATURATED_FATS")]

        cholesterol = row[Expression<Double>("CHOLESTEROL")]
        cellulose = row[Expression<Double>("CELLULOSE")]
        sodium = row[Expression<Double>("SODIUM")]
        pottassium = row[Expression<Double>("POTTASSIUM")]

        percentCarbohydrates = row[Expression<Int>("PERCENT_CARBOHYDRATES")]
        percentProteins = row[Expression<Int>("PERCENT_PROTEINS")]
        percentFats = row[Expression<Int>("PERCENT_FATS")]
    }

    required convenience init(favorite: Favorite) {
        self.init()
        
        generalKey = favorite.key
        generalFindId = favorite.key
        name = favorite.name
        brend = favorite.brand
        calories = favorite.calories
        proteins = favorite.proteins
        carbohydrates = favorite.carbohydrates
        sugar = favorite.sugar
        fats = favorite.fats
        isMineProduct = favorite.isMineProduct ?? false
        saturatedFats = favorite.saturatedFats
        monoUnSaturatedFats = favorite.monoUnSaturatedFats
        polyUnSaturatedFats = favorite.polyUnSaturatedFats
        cholesterol = favorite.cholesterol
        cellulose = favorite.cellulose
        sodium = favorite.sodium
        pottassium = favorite.pottassium
        measurementUnits = favorite.measurementUnits
    }
    
    required convenience init(mealtime: Mealtime) {
        self.init()
        
        generalFindId = mealtime.generalFindId
        parentKey = mealtime.parentKey
        generalKey = mealtime.generalKey
        day = mealtime.day
        month = mealtime.month
        year = mealtime.year
        name = mealtime.name
        brend = mealtime.brand
        presentDay = mealtime.presentDay
        calories = mealtime.calories
        proteins = mealtime.protein
        carbohydrates = mealtime.carbohydrates
        fats = mealtime.fat
        weight = mealtime.weight
        isRecipe = mealtime.isRecipe ?? false
        isMineProduct = mealtime.isMineProduct ?? false
        cholesterol = mealtime.cholesterol
        polyUnSaturatedFats = mealtime.polyUnSaturatedFats
        sodium = mealtime.sodium
        cellulose = mealtime.cellulose
        saturatedFats = mealtime.saturatedFats
        monoUnSaturatedFats = mealtime.monoUnSaturatedFats
        pottassium = mealtime.pottassium
        sugar = mealtime.sugar
        measurementUnits = mealtime.measurementUnits
        selectedUnit = mealtime.selectedUnit
        isLiquid = mealtime.isLiquid
        
        if let portionId = mealtime.portionId {
            for item in mealtime.measurementUnits where portionId == item.id {
                selectedPortion = item
                self.portionId = item.id
                break
            }
        }
    }

    required convenience init(dictionary: [String : AnyObject]) {
        self.init()

        name = dictionary["name"] as? String
        brend = dictionary["brend"] as? String
        calories = dictionary["calories"] as? Double
        productWeightByAdd = dictionary["productWeightByAdd"] as? Int
    }
    
    required convenience init(secondDictionary: [String : AnyObject]) {
        self.init()
        
        id = secondDictionary["id"] as? Int
        name = secondDictionary["name"] as? String
        portion = secondDictionary["portion"] as? Double
        isLiquid = secondDictionary["is_liquid"] as? Bool
        kilojoules = secondDictionary["kilojoules"] as? Double
        calories = secondDictionary["calories"] as? Double
        brend = secondDictionary["brand"] as? String
        carbohydrates = secondDictionary["carbohydrates"] as? Double
        sugar = secondDictionary["sugar"] as? Double
        isMineProduct = secondDictionary["isMineProduct"] as? Bool ?? false
        if let fa = secondDictionary["fats"] as? Double {
            fats = fa
        } else {
            fats = secondDictionary["fat"] as? Double
        }
        if let prot = secondDictionary["proteins"] as? Double {
            proteins = prot
        } else {
            proteins = secondDictionary["protein"] as? Double
        }
        saturatedFats = secondDictionary["saturated_fats"] as? Double
        monoUnSaturatedFats = secondDictionary["monoUnSaturatedFats"] as? Double
        polyUnSaturatedFats = secondDictionary["polyunsaturated_fats"] as? Double
        cholesterol = secondDictionary["cholesterol"] as? Double
        cellulose = secondDictionary["cellulose"] as? Double
        sodium = secondDictionary["sodium"] as? Double
        pottassium = secondDictionary["pottasium"] as? Double
        weight = secondDictionary["weight"] as? Int
        
        if let list = secondDictionary["measurement_units"] as? [NSDictionary] {
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
