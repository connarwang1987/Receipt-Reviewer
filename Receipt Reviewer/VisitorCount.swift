//
//  VisitorCount.swift
//  Receipt Reviewer
//
//  Created by Linglong Wang on 8/1/17.
//  Copyright © 2017 Connar Wang. All rights reserved.
//

import Foundation
import RealmSwift

class VisitorCount: Object{
    dynamic var date: Date = Date()
    dynamic var count: Int = Int(0)
    
    func save() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(self)
            }
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
}
