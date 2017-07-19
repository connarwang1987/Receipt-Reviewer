//
//  Item+CoreDataProperties.swift
//  Receipt Reviewer
//
//  Created by Linglong Wang on 7/18/17.
//  Copyright © 2017 Connar Wang. All rights reserved.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var itemID: String?

}
