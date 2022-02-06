//
//  CategoryViewController+CRUD.swift
//  GetirTodo
//
//  Created by Yilmaz Edis (employee ID: y84185251) on 6.02.2022.
//

import Foundation

extension CategoryViewController: CRUD {

    typealias T = Category

    //MARK: - Data Manipulation Methods
    func create(element: T) {
        do {
            try realm.write {
                realm.add(element)
            }
        } catch {
            Logger.log(what: K.ErrorMessage.create, over: error)
        }
        tableView.reloadData()
    }

    func read() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }

    func update(at indexPath: IndexPath, with element: T) {
        let oldCategory = categories![indexPath.row]
        do {
            try realm.write{
                oldCategory.setValue(element.name, forKeyPath: K.Category.name)
            }
            tableView.reloadData()
        } catch {
            Logger.log(what: K.ErrorMessage.update, over: error)
        }
    }

    func delete(at indexPath: IndexPath) {
        let categoryForDeletion = self.categories![indexPath.row]
        do {
            try self.realm.write {
                self.realm.delete(categoryForDeletion)
            }
            tableView.reloadData()
        } catch {
            Logger.log(what: K.ErrorMessage.delete, over: error)
        }
    }
}
