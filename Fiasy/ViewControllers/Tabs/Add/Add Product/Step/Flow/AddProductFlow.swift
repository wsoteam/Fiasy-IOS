//
//  AddProductFlow.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/15/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

enum TypeProduct: Int {
    case liquid = 1
    case product = 0
}

struct AddProductFlow {
    
    // MARK: - First Step -
    var productType: TypeProduct = .product
    var brend: String?
    var name: String?
    var barCode: String?
    var showAll: Bool = false
    var selectedFavorite: Favorite?
    
    var productFrom = "button"
    
    // MARK: - Second Step -
    var allServingSize: [Serving] = [Serving(name: LS(key: .CREATE_STEP_TITLE_16), unit: "\(LS(key: .GRAMS_UNIT)).", size: 100)]
    
    // MARK: - Second Step -
    var calories: String?
    var fat: String?
    var carbohydrates: String?
    var protein: String?
    
    // MARK: - Third Step -
    var cellulose: String?
    var sugar: String?
    var saturatedFats: String?
    var monounsaturatedFats: String?
    var polyunsaturatedFats: String?
    var cholesterol: String?
    var sodium: String?
    var potassium: String?
    
    func getFields() -> [String] {
        return [cellulose ?? "", sugar ?? "", saturatedFats ?? "", monounsaturatedFats ?? "", polyunsaturatedFats ?? "", cholesterol ?? "", sodium ?? "", potassium ?? ""]
    }
}
