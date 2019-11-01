//
//  Measuring.swift
//  Fiasy
//
//  Created by Yuriy Sokirko on 10/27/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

enum MeasuringType {
    case weight
    case waist
    case chest
    case hips
}

class Measuring {
    
    var generalKey: String?
    
    var type: MeasuringType
    var key: String?
    var date: Date?
    var timeInMillis: Int = 0
    var weight: Double?
    
    init() {
        self.type = .weight
        self.key = ""
        self.date = Date()
        self.timeInMillis = 0
        self.weight = 0.0
    }
    
    init(generalKey: String, dictionary: [String : AnyObject], type: MeasuringType) {
        
        self.generalKey = generalKey
        self.type = type
        
        key = dictionary["key"] as? String
        timeInMillis = dictionary["timeInMillis"] as? Int ?? 0
        if let fillDate = dictionary["timeInMillis"] as? Int {
            let some = Date(timeIntervalSince1970: Double((fillDate)) / 1000.0)
            let calendar = Calendar.current
            date = calendar.date(byAdding: .hour, value: 2, to: some)
        }
        weight = dictionary["weight"] as? Double
    }
}
