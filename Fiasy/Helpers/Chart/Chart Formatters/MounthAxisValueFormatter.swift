//
//  MounthAxisValueFormatter.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/8/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import Foundation
import Charts

public class MounthAxisValueFormatter: NSObject, IAxisValueFormatter {
    
    weak var chart: BarLineChartViewBase?
    private var array: [String] = []
    
    let months = ["Jan", "Feb", "Mar",
                  "Apr", "May", "Jun",
                  "Jul", "Aug", "Sep",
                  "Oct", "Nov", "Dec"]
    
    init(chart: BarLineChartViewBase, array: [String]) {
        self.chart = chart
        self.array = array
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if array.indices.contains(Int(value)) {
            return array[Int(value)]
        } else {
            return ""
        }
    }
}

