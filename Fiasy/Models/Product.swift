//
//  Product.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/22/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import SQLite

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

    var percentCarbohydrates: Int?
    var percentFats: Int?
    var percentProteins: Int?

    init(row: Row) {
        
        id = row[Expression<Int>("ID")]
        name = row[Expression<String>("NAME")]
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
}

//class Product: Codable {
//    let listOfGroupsOfFood: [ListOfGroupsOfFood]?
//    let name: String?
//
//    init(listOfGroupsOfFood: [ListOfGroupsOfFood]?, name: String?) {
//        self.listOfGroupsOfFood = listOfGroupsOfFood
//        self.name = name
//    }
//}
//
//class ListOfGroupsOfFood: Codable {
//    let listOfFoodItems: [ListOfFoodItem]?
//    let name: String?
//    let urlOfImage: URLOfImage?
//
//    enum CodingKeys: String, CodingKey {
//        case listOfFoodItems, name
//        case urlOfImage = "url_of_image"
//    }
//
//    init(listOfFoodItems: [ListOfFoodItem]?, name: String?, urlOfImage: URLOfImage?) {
//        self.listOfFoodItems = listOfFoodItems
//        self.name = name
//        self.urlOfImage = urlOfImage
//    }
//}
//
//class ListOfFoodItem: Codable {
//    let calories, carbohydrates, composition, description: String?
//    let fat, name, properties, protein: String?
//    let urlOfImages: String?
//
//    enum CodingKeys: String, CodingKey {
//        case calories, carbohydrates, composition, description, fat, name, properties, protein
//        case urlOfImages = "url_of_images"
//    }
//
//    init(calories: String?, carbohydrates: String?, composition: String?, description: String?, fat: String?, name: String?, properties: String?, protein: String?, urlOfImages: String?) {
//        self.calories = calories
//        self.carbohydrates = carbohydrates
//        self.composition = composition
//        self.description = description
//        self.fat = fat
//        self.name = name
//        self.properties = properties
//        self.protein = protein
//        self.urlOfImages = urlOfImages
//    }
//}
//
//enum URLOfImage: String, Codable {
//    case url = "url"
//}
