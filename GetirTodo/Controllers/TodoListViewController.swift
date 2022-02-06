//
//  TodoListViewController.swift
//  GetirTodo
//
//  Created by Yilmaz Edis (employee ID: y84185251) on 5.02.2022.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController, CRUD {

    @IBOutlet weak var searchBar: UISearchBar!

    typealias T = Item
    var itemArray: Results<Item>?
    let realm = try! Realm()

    var selectedCategory : Category? {
        didSet{
            read()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = K.rowHeight
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressToUpdate))
        tableView.addGestureRecognizer(longPress)
    }

    override func viewWillAppear(_ animated: Bool) {
        if let category = selectedCategory {
            let title = category.name
            configureNavigationBar(largeTitleColor: .white, backgoundColor: .systemBlue, tintColor: .white, title: title, preferredLargeTitle: true)
            searchBar.barTintColor = .systemOrange
        }
    }

    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cell, for: indexPath)
        let item = itemArray![indexPath.row]

        cell.textLabel?.text = item.title
        cell.backgroundColor = .systemGreen
        cell.textLabel?.textColor = .white
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }

    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        updateDone(at: indexPath)

        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delete(at: indexPath)
        }
    }

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

    //MARK: - Update Action -
    @objc func longPressToUpdate(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                alertControllerView(act: ActionType.Update) { (text) in
                    let newItem = Item()
                    newItem.title = text
                    newItem.dateCreated = Date()

                    self.update(at: indexPath, with: newItem)
                }
            }
        }
    }

    //MARK: - Add Action -
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        alertControllerView(act: ActionType.Add) { (text) in
            let newItem = Item()
            newItem.title = text
            newItem.dateCreated = Date()
            self.create(element: newItem)
        }
    }
}
