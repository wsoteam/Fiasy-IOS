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
        
        name = favorite.name
        brend = favorite.brand
        calories = favorite.calories
        proteins = favorite.proteins
        carbohydrates = favorite.carbohydrates
        sugar = favorite.sugar
        fats = favorite.fats
        saturatedFats = favorite.saturatedFats
        monoUnSaturatedFats = favorite.monoUnSaturatedFats
        polyUnSaturatedFats = favorite.polyUnSaturatedFats
        cholesterol = favorite.cholesterol
        cellulose = favorite.cellulose
        sodium = favorite.sodium
        pottassium = favorite.pottassium
        measurementUnits = favorite.measurementUnits
    }
    
//    required convenience init(second: SecondProduct, portion: MeasurementUnits) {
//        self.init()
//        
//        id = second.id
//        name = second.name
//        brend = second.brand?.name
//        calories = second.calories
//        proteins = second.proteins
//        carbohydrates = second.carbohydrates
//        sugar = second.sugar
//        fats = second.fats
//        saturatedFats = second.saturatedFats
//        monoUnSaturatedFats = second.monoUnSaturatedFats
//        polyUnSaturatedFats = second.polyUnSaturatedFats
//        cholesterol = second.cholesterol
//        cellulose = second.cellulose
//        sodium = second.sodium
//        pottassium = second.pottassium
//        selectedPortion = portion
//    }

    required convenience init(mealtime: Mealtime) {
        self.init()
        
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
}
