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
    
    func tomorrow() -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.setValue(1, for: .day)
        
        let tomorrow = Calendar.current.date(byAdding: dateComponents, to: self)
        
        return tomorrow!
    }
}
