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
    
    var count: Int?
    var next: String?
    var previous: String?
    var results: [SecondProduct] = []
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        count <- map["count"]
        next <- map["next"]
        previous <- map["previous"]
        results <- map["results"]
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
    }
}
