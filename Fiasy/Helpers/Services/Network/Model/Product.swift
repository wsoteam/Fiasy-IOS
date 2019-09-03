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

//class Product: NSObject, Mappable {
//
//    private static let keyType = "id"
//
//    var id: Int!
//    var name: String?
//    var portion: Int?
//    var isLiquid: Bool?
//    var kilojoules: Double?
//    var calories: Double?
//    var proteins: Double?
//    var carbohydrates: Double?
//    var sugar: Double?
//    var fats: Double?
//    var saturatedFats: Double?
//    var monoUnSaturatedFats: Double?
//    var polyUnSaturatedFats: Double?
//    var cholesterol: Double?
//    var cellulose: Double?
//    var sodium: Double?
//    var pottassium: Double?
//
//    required convenience init?(map: Map) {
//        guard let _ = map.JSON[Product.keyType] else {
//            return nil
//        }
//        self.init()
//    }
//
//    func mapping(map: Map) {
//        id <- map[Product.keyType]
//        name <- map["name"]
//        portion <- map["portion"]
//        isLiquid <- map["is_liquid"]
//        kilojoules <- map["kilojoules"]
//        calories <- map["calories"]
//        proteins <- map["proteins"]
//        carbohydrates <- map["carbohydrates"]
//        sugar <- map["sugar"]
//        fats <- map["fats"]
//        saturatedFats <- map["fats"]
//        monoUnSaturatedFats <- map["fats"]
//        polyUnSaturatedFats <- map["fats"]
//        cholesterol <- map["fats"]
//        cellulose <- map["fats"]
//        sodium <- map["fats"]
//        pottassium <- map["fats"]
//    }
//
//    required convenience init(row: Row) {
//        self.init()
//
//        id = row[Expression<Int>("ID")]
//        name = row[Expression<String>("NAME")].replacingOccurrences(of: "\"", with: "")
//        brend = row[Expression<String>("BREND")]
//        portion = row[Expression<Double>("PORTION")]
//        isLiquid = row[Expression<Bool>("IS_LIQUID")]
//        kilojoules = row[Expression<Double>("KILOJOULES")]
//        calories = row[Expression<Double>("CALORIES")]
//        proteins = row[Expression<Double>("PROTEINS")]
//        carbohydrates = row[Expression<Double>("CARBOHYDRATES")]
//        sugar = row[Expression<Double>("SUGAR")]
//        fats = row[Expression<Double>("FATS")]
//        saturatedFats = row[Expression<Double>("SATURATED_FATS")]
//        monoUnSaturatedFats = row[Expression<Double>("MONO_UN_SATURATED_FATS")]
//        polyUnSaturatedFats = row[Expression<Double>("POLY_UN_SATURATED_FATS")]
//
//        cholesterol = row[Expression<Double>("CHOLESTEROL")]
//        cellulose = row[Expression<Double>("CELLULOSE")]
//        sodium = row[Expression<Double>("SODIUM")]
//        pottassium = row[Expression<Double>("POTTASSIUM")]
//
//        percentCarbohydrates = row[Expression<Int>("PERCENT_CARBOHYDRATES")]
//        percentProteins = row[Expression<Int>("PERCENT_PROTEINS")]
//        percentFats = row[Expression<Int>("PERCENT_FATS")]
//    }
//
//    required convenience init(favorite: Favorite) {
//        self.init()
//
//        name = favorite.name
//        brend = favorite.brand
//        calories = favorite.calories
//        proteins = favorite.proteins
//        carbohydrates = favorite.carbohydrates
//        sugar = favorite.sugar
//        fats = favorite.fats
//        saturatedFats = favorite.saturatedFats
//        monoUnSaturatedFats = favorite.monoUnSaturatedFats
//        polyUnSaturatedFats = favorite.polyUnSaturatedFats
//        cholesterol = favorite.cholesterol
//        cellulose = favorite.cellulose
//        sodium = favorite.sodium
//        pottassium = favorite.pottassium
//    }
//
//    required convenience init(dictionary: [String : AnyObject]) {
//        self.init()
//
//        name = dictionary["name"] as? String
//        brend = dictionary["brend"] as? String
//        calories = dictionary["calories"] as? Double
//        productWeightByAdd = dictionary["productWeightByAdd"] as? Int
//    }
//}

class Product: NSObject {

    var id: Int?
    var name: String!
    var brend: String?
    var portion: Double?
    var isLiquid: Bool?
    var kilojoules: Double?
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
    }

    required convenience init(dictionary: [String : AnyObject]) {
        self.init()

        name = dictionary["name"] as? String
        brend = dictionary["brend"] as? String
        calories = dictionary["calories"] as? Double
        productWeightByAdd = dictionary["productWeightByAdd"] as? Int
    }
}
