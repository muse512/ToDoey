//
//  Category.swift
//  ToDoey
//
//  Created by Taylor Batch on 9/13/18.
//  Copyright © 2018 burgeoning. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
   @objc dynamic var name: String = ""
   let items = List<Item>()
   @objc dynamic var bgColor: String = ""
}
