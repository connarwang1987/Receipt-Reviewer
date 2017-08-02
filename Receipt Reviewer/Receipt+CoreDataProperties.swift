//
//  Receipt+CoreDataProperties.swift
//  
//
//  Created by Linglong Wang on 8/1/17.
//
//

import Foundation
import CoreData


extension Receipt {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Receipt> {
        return NSFetchRequest<Receipt>(entityName: "Receipt")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var type: String?
    @NSManaged public var title: String?
    @NSManaged public var receiptID: String?
    @NSManaged public var total: Double

}
