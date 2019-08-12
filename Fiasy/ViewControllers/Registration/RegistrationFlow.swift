//
//  RegistrationFlow.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/31/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

struct RegistrationFlow {

    var firstName: String = "default"
    var lastName: String = "default"
    var email: String = ""
    var gender: Int?
    var photoUrl: String = ""
    var growth: Int = 154
    var weight: Double = 50.0
    var dateOfBirth: Date?
    var loadActivity: CGFloat = 0.0
    var target: Int?
    
    static func fetchActivityCoefficient(value: CGFloat) -> Double {
        switch value {
        case 0.0:
            return 1.2
        case 1.0:
            return 1.37
        case 2.0:
            return 1.46
        case 3.0:
            return 1.55
        case 4.0:
            return 1.63
        case 5.0:
            return 1.72
        case 6.0:
            return 1.9
        default:
            return 1.37
        }
    }
    
    static func fetchResultByAdjustmentCoefficient(target: Int?, count: Double) -> Double {
        guard let value = target else { return 0.0 }
        switch value {
        case 0:
            return count
        case 1:
            return count - (count * 0.15)
        case 2:
            return count + (count * 0.30)
        case 3:
            return count - (count * 0.10)
        default:
            return count
        }
    }
}
