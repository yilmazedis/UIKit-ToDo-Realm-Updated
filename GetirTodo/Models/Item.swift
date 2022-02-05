//
//  Item.swift
//  GetirTodo
//
//  Created by Yilmaz Edis (employee ID: y84185251) on 5.02.2022.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
