//
//  Item.swift
//  Todoey
//
//  Created by Alberto Ayala on 10/4/18.
//  Copyright © 2018 Alberto A Ayala. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    // Neccessary to link item to parent category using realm
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
