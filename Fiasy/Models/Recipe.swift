//
//  Recipe.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/5/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

enum RecipeType {
    case lunch
    case snack
    case dinner
    case breakfast
}

class SecondRecipe {
    
    var cholesterol: Int?
    var time: Int?
    var potassium: Double?
    var calories: Int?
    var sugar: Double?
    var percentProteins: Double?
    var percentCarbohydrates: Double?
    var percentFats: Double?
    var recipeName: String?
    var unSaturatedFats: Double?
    var portions: Int?
    var imageUrl: String?
    var instructions: [String]?
    var ingredients: [String]?
    var cellulose: Double?
    var carbohydrates: Double?
    var fats: Double?
    var proteins: Double?
    var sodium: Double? 
    var saturatedFats: Double? 
    var description: String?
    var isDinner: Bool = false
    var isLunch: Bool = false
    var isSnack: Bool = false
    var isBreakfast: Bool = false
    
    init(dictionary: [String : AnyObject]) {
        potassium = dictionary["potassium"] as? Double
        cholesterol = dictionary["cholesterol"] as? Int
        time = dictionary["time"] as? Int
        cellulose = dictionary["cellulose"] as? Double
        calories = dictionary["calories"] as? Int
        sugar = dictionary["sugar"] as? Double
        percentCarbohydrates = dictionary["percentCarbohydrates"] as? Double
        percentProteins = dictionary["percentProteins"] as? Double
        percentFats = dictionary["percentFats"] as? Double
        recipeName = dictionary["name"] as? String
        unSaturatedFats = dictionary["unSaturatedFats"] as? Double
        portions = dictionary["portions"] as? Int
        imageUrl = dictionary["url"] as? String
        instructions = dictionary["instruction"] as? [String]
        ingredients = dictionary["ingredients"] as? [String]
        carbohydrates = dictionary["carbohydrates"] as? Double
        fats = dictionary["fats"] as? Double
        proteins = dictionary["proteins"] as? Double
        sodium = dictionary["sodium"] as? Double
        saturatedFats = dictionary["saturatedFats"] as? Double
        description = dictionary["description"] as? String
        
        if let lunch = dictionary["lunch"] as? [String], let first = lunch.first, !first.isEmpty {
            isLunch = true
        }
        
        if let breakfast = dictionary["breakfast"] as? [String], let first = breakfast.first, !first.isEmpty {
            isBreakfast = true
        } 
        if let snack = dictionary["snack"] as? [String], let first = snack.first, !first.isEmpty {
            isSnack = true
        }
        
        if let dinner = dictionary["dinner"] as? [String], let first = dinner.first, !first.isEmpty {
            isDinner = true
        }
    }
}

// MARK: - Recipe
class Recipe: Codable {
    let listrecipes: [Listrecipe]?
    let name: String?
    
    init(listrecipes: [Listrecipe]?, name: String?) {
        self.listrecipes = listrecipes
        self.name = name
    }
}

// MARK: - Listrecipe
class Listrecipe: Codable {
    let calories: Int?
    let carbohydrates, cellulose: Double?
    let cholesterol: Int?
    let listrecipeDescription: String?
    let diet: [Diet]?
    let eating: [Eating]?
    let fats: Double?
    let ingredients: [[Ingredient]]?
    let weight: Double?
    let units: Units?
    let instruction: [String]?
    let name: String?
    let percentCarbohydrates, percentFats, percentProteins, portions: Int?
    let potassium: Int?
    let proteins, saturatedFats: Double?
    let sodium: Int?
    let sugar: Double?
    let time: Int?
    let unSaturatedFats: Double?
    let url: String?
    var key: String?
    var ingredientsList: [String]?
    var complexity: String?
    var selectedProduct: [Product] = []
    
    enum CodingKeys: String, CodingKey {
        case calories, carbohydrates, cellulose, cholesterol
        case listrecipeDescription
        case diet, eating, fats, ingredients, weight, units, instruction, name, percentCarbohydrates, percentFats, percentProteins, portions, potassium, proteins, saturatedFats, sodium, sugar, time, unSaturatedFats, url
    }
    
    required init(calories: Int?, carbohydrates: Double?, cellulose: Double?, cholesterol: Int?, listrecipeDescription: String?, diet: [Diet]?, eating: [Eating]?, fats: Double?, ingredients: [[Ingredient]]?, weight: Double?, units: Units?, instruction: [String]?, name: String?, percentCarbohydrates: Int?, percentFats: Int?, percentProteins: Int?, portions: Int?, potassium: Int?, proteins: Double?, saturatedFats: Double?, sodium: Int?, sugar: Double?, time: Int?, unSaturatedFats: Double?, url: String?) {
        self.calories = calories
        self.carbohydrates = carbohydrates
        self.cellulose = cellulose
        self.cholesterol = cholesterol
        self.listrecipeDescription = listrecipeDescription
        self.diet = diet
        self.eating = eating
        self.fats = fats
        self.ingredients = ingredients
        self.weight = weight
        self.units = units
        self.instruction = instruction
        self.name = name
        self.percentCarbohydrates = percentCarbohydrates
        self.percentFats = percentFats
        self.percentProteins = percentProteins
        self.portions = portions
        self.potassium = potassium
        self.proteins = proteins
        self.saturatedFats = saturatedFats
        self.sodium = sodium
        self.sugar = sugar
        self.time = time
        self.unSaturatedFats = unSaturatedFats
        self.url = url
    }
    
    required convenience init (generalKey: String, dictionary: [String : AnyObject]) {

        self.init(calories: dictionary["calories"] as? Int, carbohydrates: dictionary["carbohydrates"] as? Double, cellulose: dictionary["cellulose"] as? Double, cholesterol: dictionary["cholesterol"] as? Int, listrecipeDescription: "", diet: [], eating: [Eating(rawValue: "dinner")!], fats: 0.0, ingredients: [], weight: dictionary["weight"] as? Double, units: Units(rawValue: "г"), instruction: dictionary["instruction"] as? [String], name: dictionary["name"] as? String, percentCarbohydrates: nil, percentFats: nil, percentProteins: nil, portions: 1, potassium: dictionary["potassium"] as? Int, proteins: dictionary["proteins"] as? Double, saturatedFats: dictionary["saturatedFats"] as? Double, sodium: dictionary["sodium"] as? Int, sugar: dictionary["sugar"] as? Double, time: dictionary["time"] as? Int, unSaturatedFats: 0.0, url: dictionary["url"] as? String)
        
        self.key = generalKey
        self.complexity = dictionary["complexity"] as? String
        if let array = dictionary["selectedProducts"] as? NSArray {
            for item in array where ((item as? [String : AnyObject]) != nil) {
                selectedProduct.append(Product(dictionary: item as! [String : AnyObject]))
            }
        }
    }
}

enum Diet: String, Codable {
    case classic = "classic"
    case clear = "clear"
    case highLCHF = "highLCHF"
    case keto = "keto"
    case lowLCHF = "lowLCHF"
    case mediterranean = "mediterranean"
    case mediumLCHF = "mediumLCHF"
    case prot = "prot"
    case scand = "scand"
    case the3Week = "3week"
    case vegan = "vegan"
}

enum Eating: String, Codable {
    case breakfast = "breakfast"
    case dinner = "dinner"
    case lunch = "lunch"
    case snack = "snack"
}

enum Ingredient: Codable {
    case double(Double)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Ingredient.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Ingredient"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

enum Units: String, Codable {
    case г = "г"
    case мл = "мл"
}
