//
//  AddRecipeFlow.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/16/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

struct AddRecipeFlow {
    
    // MARK: - First Step -
    var recipeName: String?
    var recipeImage: UIImage?
    var time: String?
    var complexity: String?
    var showAll: Bool = false
    
    var recipeFrom = "button"
    
    // MARK: - Third Step -
    var allProduct: [Product] = []

    // MARK: - Four Step -
    var instructionsList: [String] = []
    
    // MARK: - Edit Flow -
    var recipe: Listrecipe?

}
