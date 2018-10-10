//
//  Category.swift
//  Todoey
//
//  Created by Alberto Ayala on 10/4/18.
//  Copyright © 2018 Alberto A Ayala. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var cellColor: String = ""
    
    // Neccessary to link what items are related to this category
    let items = List<Item>()
}
