//
//  Item.swift
//  Receipt Reviewer
//
//  Created by Linglong Wang on 7/12/17.
//  Copyright © 2017 Connar Wang. All rights reserved.
//

import Foundation

enum ReceiptType: String {
    case Transportation = "Transportation"
    case Travel = "Travel"
    case Health = "Health"
    case Others = "Others"
    case Grocery = "Grocery"
    case OutsideDinning = "Outside Dinning"
    case Entertainment = "Entertainment"
    case Business = "Business"
    case EmptyString = ""
    case Bill = "Bill"
    case Activity = "Activity"
    case Rent = "Rent"
    
    static var allValues: [ReceiptType] {
        return [.Transportation, .Travel, .Health, .Others, .Grocery, .OutsideDinning, .Entertainment, .Business, .EmptyString, .Bill, .Activity, .Rent]
    }
}
