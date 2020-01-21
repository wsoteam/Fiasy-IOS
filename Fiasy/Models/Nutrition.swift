//
//  Nutrition.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 1/21/20.
//  Copyright © 2020 Eugen Lipatov. All rights reserved.
//

import UIKit

class Nutrition {

    var name: String?
    var properties: String?
    var list: [NutritionDetail] = []
    
    init(dictionary: [String : AnyObject]) {
        name = dictionary["name"] as? String
        properties = dictionary["properties"] as? String
        if let lists = dictionary["dietPlans"] as? NSMutableArray {
            for item in lists {
                if let dictionary = item as? [String : AnyObject] {
                    list.append(NutritionDetail(dictionary: dictionary))
                }
            }
        }
    }
}

class NutritionDetail {
    
    var flag: String?
    var text: String?
    var name: String?
    var urlImage: String?
    var countDays: Int?
    var premium: Bool?
    
    init(dictionary: [String : AnyObject]) {
        name = dictionary["name"] as? String
        flag = dictionary["flag"] as? String
        text = dictionary["text"] as? String
        urlImage = dictionary["urlImage"] as? String
        countDays = dictionary["countDays"] as? Int
        premium = dictionary["premium"] as? Bool
    }
}
