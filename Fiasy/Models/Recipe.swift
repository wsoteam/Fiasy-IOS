//
//  Recipe.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/5/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

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
    
    enum CodingKeys: String, CodingKey {
        case calories, carbohydrates, cellulose, cholesterol
        case listrecipeDescription
        case diet, eating, fats, ingredients, weight, units, instruction, name, percentCarbohydrates, percentFats, percentProteins, portions, potassium, proteins, saturatedFats, sodium, sugar, time, unSaturatedFats, url
    }
    
    init(calories: Int?, carbohydrates: Double?, cellulose: Double?, cholesterol: Int?, listrecipeDescription: String?, diet: [Diet]?, eating: [Eating]?, fats: Double?, ingredients: [[Ingredient]]?, weight: Double?, units: Units?, instruction: [String]?, name: String?, percentCarbohydrates: Int?, percentFats: Int?, percentProteins: Int?, portions: Int?, potassium: Int?, proteins: Double?, saturatedFats: Double?, sodium: Int?, sugar: Double?, time: Int?, unSaturatedFats: Double?, url: String?) {
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


