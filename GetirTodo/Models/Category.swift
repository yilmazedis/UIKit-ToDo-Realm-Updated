//
//  Category.swift
//  GetirTodo
//
//  Created by Yilmaz Edis (employee ID: y84185251) on 5.02.2022.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
