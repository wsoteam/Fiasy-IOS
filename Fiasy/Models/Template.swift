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
    var fields: [String] = []
    
    init(generalKey: String, dictionary: [String : AnyObject]) {
        name = dictionary["name"] as? String
        
        if let item = dictionary["fields"] as? String {
            fields = item.split{$0 == ","}.map(String.init)
        }
    }
}
