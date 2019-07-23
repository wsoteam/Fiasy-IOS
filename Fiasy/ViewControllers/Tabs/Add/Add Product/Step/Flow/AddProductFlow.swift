//
//  AddProductFlow.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/15/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

struct AddProductFlow {
    
    // MARK: - First Step -
    var brend: String?
    var name: String?
    var barCode: String?
    var showAll: Bool = true
    
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
    
}
