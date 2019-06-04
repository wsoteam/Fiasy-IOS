//
//  Recipe.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/5/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class Recipe: Codable {
    let listrecipes: [Listrecipe]?
    let name: String?
    
    init(listrecipes: [Listrecipe]?, name: String?) {
        self.listrecipes = listrecipes
        self.name = name
    }
}

class Listrecipe: Codable {
    let calories: Int?
    let carbohydrates, cellulose: Double?
    let cholesterol: Int?
    let description: String?
    let diet: [Diet]?
    let eating: [Eating]?
    let fats: Double?
    let ingredients, instruction: [String]?
    let name: String?
    let percentCarbohydrates, percentFats, percentProteins, portions: Int?
    let potassium: Int?
    let proteins, saturatedFats: Double?
    let sodium: Int?
    let sugar: Double?
    let time: Int?
    let unSaturatedFats: Double?
    let url: String?
    
    init(calories: Int?, carbohydrates: Double?, cellulose: Double?, cholesterol: Int?, description: String?, diet: [Diet]?, eating: [Eating]?, fats: Double?, ingredients: [String]?, instruction: [String]?, name: String?, percentCarbohydrates: Int?, percentFats: Int?, percentProteins: Int?, portions: Int?, potassium: Int?, proteins: Double?, saturatedFats: Double?, sodium: Int?, sugar: Double?, time: Int?, unSaturatedFats: Double?, url: String?) {
        self.calories = calories
        self.carbohydrates = carbohydrates
        self.cellulose = cellulose
        self.cholesterol = cholesterol
        self.description = description
        self.diet = diet
        self.eating = eating
        self.fats = fats
        self.ingredients = ingredients
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

