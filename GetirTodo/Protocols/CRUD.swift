//
//  CRUD.swift
//  GetirTodo
//
//  Created by Yilmaz Edis (employee ID: y84185251) on 6.02.2022.
//

import UIKit

protocol CRUD {

    associatedtype T

    func create(element: T)
    func read()
    func update(at indexPath: IndexPath, with name: String)
    func delete(at indexPath: IndexPath)
}
