//
//  Template.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class Template {

    var generalKey: String?
    
    var name: String?
    var products: [SecondProduct] = []
    
    init(generalKey: String, dictionary: [String : AnyObject]) {
        self.generalKey = generalKey
        self.name = dictionary["name"] as? String
        
        if let array = dictionary["list"] as? NSArray {
            for second in array {
                if let dictionary = second as? [String : AnyObject] {
                    let product = SecondProduct(secondDictionary: dictionary)
                    self.products.append(product)
                }
            }
        }
    }
}
