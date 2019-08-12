//
//  ChartsFlow.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/8/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ChartsFlow {
    
    static func fetchValues(chartsState: ChartsState, array: [String], date: Date, _ mounths: [[Int]], _ weakArray: [Int]) -> [Double] {
        let day = Calendar(identifier: .iso8601).ordinality(of: .day, in: .month, for: date)!
        let month = Calendar(identifier: .iso8601).ordinality(of: .month, in: .year, for: date)!
        let year = Calendar(identifier: .iso8601).ordinality(of: .year, in: .era, for: date)!
        
        var fakeArray: [Double] = []
        for _ in array {
            fakeArray.append(0.0)
        }
        switch chartsState {
        case .week:
            for item in UserInfo.sharedInstance.allMealtime where item.year == year && month == item.month {
                for (index, items) in weakArray.enumerated() where items == item.day {
                    fakeArray[index] = fakeArray[index] + Double(item.calories ?? 0)
                }
            }
            return fakeArray
        case .mounth:
            for item in UserInfo.sharedInstance.allMealtime where item.year == year && month == item.month {
                for (index, items) in mounths.enumerated() where items.contains(item.day ?? 1) {
                    fakeArray[index] = fakeArray[index] + Double(item.calories ?? 0)
                }
            }
            return fakeArray
        case .year:
            for item in UserInfo.sharedInstance.allMealtime where item.year == year {
                if fakeArray.indices.contains(item.month ?? 0) {
                    fakeArray[(item.month ?? 0) - 1] = fakeArray[(item.month ?? 0) - 1] + Double(item.calories ?? 0)
                }
            }
            return fakeArray
        }
    }
}
