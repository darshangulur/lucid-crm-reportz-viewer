//
//  DayAxisValueFormatter.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-09.
//  Copyright © 2017 jc. All rights reserved.
//

import Foundation
import Charts

public class StringValueFormatter: NSObject, IAxisValueFormatter {
    weak var chart: BarLineChartViewBase?

    private let strings: [String]
    init(chart: BarLineChartViewBase, strings: [String]) {
        self.chart = chart
        self.strings = strings
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return strings[Int(value) % strings.count]
    }
}
