//
//  Receipt+CoreDataProperties.swift
//  Receipt Reviewer
//
//  Created by Linglong Wang on 7/13/17.
//  Copyright © 2017 Connar Wang. All rights reserved.
//

import Foundation
import CoreData


extension Receipt {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Receipt> {
        return NSFetchRequest<Receipt>(entityName: "Receipt")
    }

    @NSManaged public var title: String?
    @NSManaged public var date: NSDate?

}
