//
//  TodoListViewController+CRUD.swift
//  GetirTodo
//
//  Created by Yilmaz Edis (employee ID: y84185251) on 6.02.2022.
//

import Foundation

extension TodoListViewController: CRUD {
    typealias T = Item

    //MARK: - Model Manupulation Methods -
    func create(element: Item) {
        if let currentCategory = self.selectedCategory {
            do {
                try self.realm.write {
                    currentCategory.items.append(element)
                }
            } catch {
                Logger.log(what: K.ErrorMessage.create, over: error)
            }
        }
        self.tableView.reloadData()
    }

    func read() {
        guard let elements = selectedCategory?.items.sorted(byKeyPath: K.Item.title, ascending: true) else {
            Logger.log(what: K.ErrorMessage.read, about: .error)
            return
        }
        itemArray = elements
        tableView.reloadData()
    }

    func update(at indexPath: IndexPath, with element: Item) {
        let oldItem = itemArray![indexPath.row]
        do {
            try realm.write{
                oldItem.setValue(element.title, forKeyPath: K.Item.title)
                oldItem.setValue(element.done, forKeyPath: K.Item.done)
                oldItem.setValue(element.dateCreated, forKeyPath: K.Item.dateCreated)
            }
            tableView.reloadData()
        } catch {
            Logger.log(what: K.ErrorMessage.update, over: error)
        }
    }

    func delete(at indexPath: IndexPath) {
        let item = itemArray![indexPath.row]
        do {
            try realm.write{
                realm.delete(item)
            }
            tableView.reloadData()
        } catch {
            Logger.log(what: K.ErrorMessage.delete, over: error)
        }
    }

    func updateDone(at indexPath: IndexPath) {
        let item = itemArray![indexPath.row]
        do {
            try realm.write{
                item.done = !item.done
            }
        } catch {
            Logger.log(what: K.ErrorMessage.create, over: error)
        }
    }
}
