//
//  YearAxisValueFormatter.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/8/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import Foundation
import Charts

public class YearAxisValueFormatter: NSObject, IAxisValueFormatter {
    
    weak var chart: BarLineChartViewBase?
    
    init(chart: BarLineChartViewBase) {
        self.chart = chart
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        switch Int(value) {
        case 0:
            return String(LS(key: .JANUARY).prefix(3)) 
        case 1:
            return String(LS(key: .FEBRUARY).prefix(3)) 
        case 2:
            return String(LS(key: .MARCH).prefix(3)) 
        case 3:
            return String(LS(key: .APRIL).prefix(3)) 
        case 4:
            return String(LS(key: .MAY).prefix(3)) 
        case 5:
            return String(LS(key: .JUNE).prefix(3)) 
        case 6:
            return String(LS(key: .JULY).prefix(3)) 
        case 7:
            return String(LS(key: .AUGUST).prefix(3)) 
        case 8:
            return String(LS(key: .SEPTEMBER).prefix(3)) 
        case 9:
            return String(LS(key: .OCTOBER).prefix(3)) 
        case 10:
            return String(LS(key: .NOVEMBER).prefix(3)) 
        case 11:
            return String(LS(key: .DECEMBER).prefix(3)) 
        default:
            return ""
        }
    }
}


