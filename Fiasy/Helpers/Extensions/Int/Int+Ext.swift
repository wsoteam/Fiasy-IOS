//
//  Int+Ext.swift
//  Fiasy
//
//  Created by Yuriy Sokirko on 10/27/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

extension Int {
    
    func dateFromMilliseconds(format: String) -> Date {
        let date = Date(timeIntervalSince1970: Double((self)) / 1000.0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        let timeStamp = dateFormatter.string(from: date)

        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(identifier: "GMT")
        return ( formatter.date( from: timeStamp ) )!
    }
}

extension Date {
    
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    init(millis: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(millis / 1000))
        self.addTimeInterval(TimeInterval(Double(millis % 1000) / 1000 ))
    }
    
}
