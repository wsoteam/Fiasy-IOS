//
//  CalendarItem.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/8/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Parchment

struct CalendarItem: PagingItem, Hashable, Comparable {
    let date: Date
    let dateText: String
    let weekdayText: String
    
    init(date: Date) {
        self.date = date
        self.dateText = DateFormatters.dateFormatter.string(from: date)
        self.weekdayText = DateFormatters.weekdayFormatter.string(from: date)
    }
    
    var hashValue: Int {
        return date.hashValue
    }
    
    static func ==(lhs: CalendarItem, rhs: CalendarItem) -> Bool {
        return lhs.date == rhs.date
    }
    
    static func <(lhs: CalendarItem, rhs: CalendarItem) -> Bool {
        return lhs.date < rhs.date
    }
}
