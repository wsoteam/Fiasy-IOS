//
//  User.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/11/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class User {

    var age: Int?
    var firstName: String?
    var lastName: String?
    var email: String?
    var difficultyLevel: String?
    var exerciseStress: String?
    var female: Bool?
    var photoUrl: String?
    var waterCount: Int?
    var weight: Double?
    var height: Int?
    var dateRegistration: String?
    var maxFat: Int?
    var maxKcal: Int?
    var maxProt: Int?
    var maxCarbo: Int?
    var temporaryPicture: UIImage?
    var updateOfIndicator: Bool?
    
    init(dictionary: [String : AnyObject]) {
        age = dictionary["age"] as? Int
        email = dictionary["email"] as? String
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
        difficultyLevel = dictionary["difficultyLevel"] as? String
        exerciseStress = dictionary["exerciseStress"] as? String
        female = dictionary["female"] as? Bool
        photoUrl = dictionary["photoUrl"] as? String
        waterCount = dictionary["waterCount"] as? Int
        weight = dictionary["weight"] as? Double
        height = dictionary["height"] as? Int
        updateOfIndicator = dictionary["updateOfIndicator"] as? Bool
        
        let day: Int = dictionary["numberOfDay"] as? Int ?? 1
        let month: Int = dictionary["month"] as? Int ?? 1
        let year: Int = dictionary["year"] as? Int ?? 2019
        dateRegistration = "\(day < 10 ? "0" : "")\(day).\(month < 10 ? "0" : "")\(month).\(year)"
        maxFat = dictionary["maxFat"] as? Int
        maxKcal = dictionary["maxKcal"] as? Int
        maxProt = dictionary["maxProt"] as? Int
        maxCarbo = dictionary["maxCarbo"] as? Int
    }
}

