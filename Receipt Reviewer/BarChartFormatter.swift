//
//  BarChartFormatter.swift
//  Receipt Reviewer
//
//  Created by Linglong Wang on 8/4/17.
//  Copyright © 2017 Connar Wang. All rights reserved.
//

import UIKit
import Foundation
import Charts

@objc(BarChartFormatter)
public class BarChartFormatter: NSObject, IAxisValueFormatter{
    
    var months: [String]! = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        return months[Int(value)]
    }
}
