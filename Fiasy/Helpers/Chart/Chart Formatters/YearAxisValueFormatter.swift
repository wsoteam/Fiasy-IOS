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
            return "янв"
        case 1:
            return "фев"
        case 2:
            return "мар"
        case 3:
            return "апр"
        case 4:
            return "май"
        case 5:
            return "июн"
        case 6:
            return "июл"
        case 7:
            return "авг"
        case 8:
            return "сен"
        case 9:
            return "окт"
        case 10:
            return "ноя"
        case 11:
            return "дек"
        default:
            return ""
        }
    }
}


