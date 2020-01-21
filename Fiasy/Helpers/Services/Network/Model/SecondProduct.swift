//
//  SecondProduct.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/27/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import ObjectMapper

class PaginationProduct: NSObject, Mappable {
    
    var length: Int?
    var offset: Int?
    var text: String?
    var results: [ProductInfo] = []
    
    var count: Int?
    var next: String?
    var previous: String?
    var secondResults: [SecondProduct] = []
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        length <- map["length"]
        offset <- map["offset"]
        text <- map["text"]
        results <- map["options"]
        
        count <- map["count"]
        next <- map["next"]
        previous <- map["previous"]
        secondResults <- map["results"]
    }
}

class Brand: NSObject, Mappable {
    
    private static let keyType = "id"
    
    var id: Int!
    var name: String?
    
    required convenience init?(map: Map) {
        guard let _ = map.JSON[Brand.keyType] else {
            return nil
        }
        self.init()
    }
    
    func mapping(map: Map) {
        
        id <- map[Brand.keyType]
        name <- map["name"]
    }
}

class SecondProduct: Product, Mappable {
    
    private static let keyType = "id"
    
//    var id: Int!
//    var name: String?
    var brand: Brand?
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
    
    required convenience init?(map: Map) {
        guard let _ = map.JSON[SecondProduct.keyType] else {
            return nil
        }
        self.init()
    }
    
    func mapping(map: Map) {
        
        id <- map[SecondProduct.keyType]
        name <- map["name"]
        portion <- map["portion"]
        isLiquid <- map["is_liquid"]
        kilojoules <- map["kilojoules"]
        calories <- map["calories"]
        proteins <- map["proteins"]
        brand <- map["brand"]
        carbohydrates <- map["carbohydrates"]
        sugar <- map["sugar"]
        fats <- map["fats"]
        saturatedFats <- map["saturated_fats"]
        monoUnSaturatedFats <- map["monounsaturated_fats"]
        polyUnSaturatedFats <- map["polyunsaturated_fats"]
        cholesterol <- map["cholesterol"]
        cellulose <- map["cellulose"]
        sodium <- map["sodium"]
        pottassium <- map["pottasium"]
        measurementUnits <- map["measurement_units"]
        portionId <- map["portionId"]
    }
    
    required convenience init(second: SecondProduct, portion: MeasurementUnits) {
        self.init()

        id = second.id
        name = second.name
        self.portion = second.portion
        isLiquid = second.isLiquid
        kilojoules = second.kilojoules
        calories = second.calories
        proteins = second.proteins
        brand = second.brand
        carbohydrates = second.carbohydrates
        sugar = second.sugar
        fats = second.fats
        saturatedFats = second.saturatedFats
        monoUnSaturatedFats = second.monoUnSaturatedFats
        polyUnSaturatedFats = second.polyUnSaturatedFats
        cholesterol = second.cholesterol
        cellulose = second.cellulose
        sodium = second.sodium
        pottassium = second.pottassium
        measurementUnits = second.measurementUnits
        selectedPortion = portion
        portionId = second.portionId
        weight = nil
    }
    
    required convenience init(second: SecondProduct) {
        self.init()
        
        id = second.id
        name = second.name
        generalKey = second.generalKey
        generalFindId = second.generalFindId
        self.portion = second.portion
        isLiquid = second.isLiquid
        kilojoules = second.kilojoules
        calories = second.calories
        proteins = second.proteins
        brand = second.brand
        carbohydrates = second.carbohydrates
        sugar = second.sugar
        fats = second.fats
        saturatedFats = second.saturatedFats
        monoUnSaturatedFats = second.monoUnSaturatedFats
        polyUnSaturatedFats = second.polyUnSaturatedFats
        cholesterol = second.cholesterol
        cellulose = second.cellulose
        sodium = second.sodium
        pottassium = second.pottassium
        measurementUnits = second.measurementUnits
        selectedPortion = second.selectedPortion
        portionId = second.portionId
        weight = nil
    }
    
    required convenience init(second: Product) {
        self.init()
        
        id = second.id
        name = second.name
        generalKey = second.generalKey
        generalFindId = second.generalFindId
        self.portion = second.portion
        isLiquid = second.isLiquid
        kilojoules = second.kilojoules
        calories = second.calories
        proteins = second.proteins
        brend = second.brend
        carbohydrates = second.carbohydrates
        sugar = second.sugar
        fats = second.fats
        saturatedFats = second.saturatedFats
        monoUnSaturatedFats = second.monoUnSaturatedFats
        polyUnSaturatedFats = second.polyUnSaturatedFats
        cholesterol = second.cholesterol
        cellulose = second.cellulose
        sodium = second.sodium
        pottassium = second.pottassium
        measurementUnits = second.measurementUnits
        selectedPortion = second.selectedPortion
        portionId = second.portionId
        weight = nil
    }
}
