//
//  Receipt+CoreDataProperties.swift
//  
//
//  Created by Linglong Wang on 8/3/17.
//
//

import Foundation
import CoreData


extension Receipt {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Receipt> {
        return NSFetchRequest<Receipt>(entityName: "Receipt")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var receiptID: String?
    @NSManaged public var title: String?
    @NSManaged public var total: Double
    @NSManaged public var type: String?
    @NSManaged public var month: Int16
    @NSManaged public var year: Int16

}
