//
//  Serving.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/8/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class Serving {
    
    var index: Int = 0
    var name: String?
    var unitMeasurement: String?
    var servingSize: Int?
    
    init(name: String, unit: String, size: Int) {
        self.name = name
        self.servingSize = size
        self.unitMeasurement = unit
    }
}
