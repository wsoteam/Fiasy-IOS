//
//  DateFormatters.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/8/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

struct DateFormatters {
    
    static var shortDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        //dateFormatter.timeZone = .current
        //        dateFormatter.timeStyle = .none
        //        dateFormatter.dateStyle = .short
        return dateFormatter
    }()
    
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()
    
    static var weekdayFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter
    }()
}

extension Date {
    
    func yesterday() -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.setValue(-1, for: .day)
        
        let yesterday = Calendar.current.date(byAdding: dateComponents, to: self)
        
        return yesterday!
    }
//    
//    func tomorrow() -> Date {
//
//        var dateComponents = DateComponents()
//        dateComponents.setValue(1, for: .day)
//        
//        let tomorrow = Calendar.current.date(byAdding: dateComponents, to: self)
//
//        return tomorrow!
//    }
}

extension Date {
    
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.day], from: self).day
    }
    
    func getWeekDates() -> [Date] {
        var arrThisWeek: [Date] = []
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.ReferenceType.default
        for i in 0..<7 {
            arrThisWeek.append(calendar.date(byAdding: .day, value: i, to: startOfWeek)!)
        }
        return arrThisWeek
    }
    
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    var startOfWeek: Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.ReferenceType.default
        let sunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return calendar.date(byAdding: .day, value: 0, to: sunday!)!
    }
    
    func toDate(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

