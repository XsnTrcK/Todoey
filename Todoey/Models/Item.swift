//
//  TodoeyItem.swift
//  Todoey
//
//  Created by Alberto Ayala on 9/27/18.
//  Copyright © 2018 Alberto A Ayala. All rights reserved.
//

import Foundation

public class Item: Codable {
    var title : String = ""
    var done : Bool = false
    
    init(title : String) {
        self.title = title
    }
}
