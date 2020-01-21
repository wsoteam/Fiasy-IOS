//
//  Dish.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 1/12/20.
//  Copyright © 2020 Eugen Lipatov. All rights reserved.
//

import UIKit

class Dish {
    
    var generalKey: String?
    
    var generalKeyByEdit: String?
    var parentKey: String?
    var name: String?
    var imageUrl: String?
    var weight: Int? 
    var products: [SecondProduct] = []
    var createdProduct: SecondProduct?
    
//    init(generalKey: String, dictionary: [String : AnyObject]) {
//        self.generalKey = generalKey
//        self.imageUrl = dictionary["imageUrl"] as? String
//        self.name = dictionary["name"] as? String
//        
//        if let array = dictionary["list"] as? NSArray {
//            for second in array {
//                if let dictionary = second as? [String : AnyObject] {
//                    let product = SecondProduct(secondDictionary: dictionary)
//                    self.products.append(product)
//                }
//            }
//        }
//    }
    
    convenience init(generalKey: String, dictionary: [String : AnyObject]) {
        self.init()
        
        self.generalKey = generalKey
        self.imageUrl = dictionary["imageUrl"] as? String
        self.name = dictionary["name"] as? String
        
        if let array = dictionary["list"] as? NSArray {
            for second in array {
                if let dictionary = second as? [String : AnyObject] {
                    let product = SecondProduct(secondDictionary: dictionary)
                    self.products.append(product)
                }
            }
        }
    }
    
    static func fetchCreatedProduct(dish: Dish) -> SecondProduct? {
        if dish.products.isEmpty {
            return nil
        } else {
            let createdSecondProduct = SecondProduct()
            var kilojoules: Double = 0.0
            var calories: Double = 0.0
            var proteins: Double = 0.0
            var carbohydrates: Double = 0.0
            var sugar: Double = 0.0
            var fats: Double = 0.0
            var saturatedFats: Double = 0.0
            var monoUnSaturatedFats: Double = 0.0
            var polyUnSaturatedFats: Double = 0.0
            var cholesterol: Double = 0.0
            var cellulose: Double = 0.0
            var sodium: Double = 0.0
            var pottassium: Double = 0.0
            var measurementUnits: [MeasurementUnits] = []
            
            for item in dish.products {
                kilojoules += item.kilojoules ?? 0.0
                calories += item.calories ?? 0.0
                proteins += item.proteins ?? 0.0
                carbohydrates += item.carbohydrates ?? 0.0
                sugar += item.sugar ?? 0.0
                fats += item.fats ?? 0.0
                saturatedFats += item.saturatedFats ?? 0.0
                monoUnSaturatedFats += item.monoUnSaturatedFats ?? 0.0
                polyUnSaturatedFats += item.polyUnSaturatedFats ?? 0.0
                cholesterol += item.cholesterol ?? 0.0
                cellulose += item.cellulose ?? 0.0
                sodium += item.sodium ?? 0.0
                pottassium += item.pottassium ?? 0.0
                for secondItem in item.measurementUnits {
                    measurementUnits.append(secondItem)
                }
            }
            createdSecondProduct.kilojoules = kilojoules
            createdSecondProduct.calories = calories
            createdSecondProduct.proteins = proteins
            createdSecondProduct.carbohydrates = carbohydrates
            createdSecondProduct.sugar = sugar
            createdSecondProduct.fats = fats
            createdSecondProduct.saturatedFats = saturatedFats
            createdSecondProduct.monoUnSaturatedFats = monoUnSaturatedFats
            createdSecondProduct.polyUnSaturatedFats = polyUnSaturatedFats
            createdSecondProduct.cholesterol = cholesterol
            createdSecondProduct.cellulose = cellulose
            createdSecondProduct.sodium = sodium
            createdSecondProduct.pottassium = pottassium
            createdSecondProduct.measurementUnits = measurementUnits
            createdSecondProduct.isMineProduct = true
            return createdSecondProduct
        }
    }
}
