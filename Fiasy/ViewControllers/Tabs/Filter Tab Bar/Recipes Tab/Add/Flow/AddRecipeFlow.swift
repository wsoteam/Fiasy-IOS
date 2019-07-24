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
    
    // MARK: - Second Step -
    var allProduct: [Product] = []

    // MARK: - Third Step -
    var instructionsList: [String] = []
    
    // MARK: - Edit Flow -
    var recipe: Listrecipe?

}
