//
//  Expert.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/25/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class Expert {

    var id: String?
    var date: Int?
    var unlockedArticles: Int?
    
    init(dictionary: [String : AnyObject]) {
        id = dictionary["id"] as? String
        date = dictionary["date"] as? Int
        unlockedArticles = dictionary["unlockedArticles"] as? Int
    }
}


