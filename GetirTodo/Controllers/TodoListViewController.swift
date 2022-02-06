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
        tableView.rowHeight = 80.0
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressToUpdate))
        tableView.addGestureRecognizer(longPress)
    }

    override func viewWillAppear(_ animated: Bool) {
        if let category = selectedCategory {
            let title = category.name
            configureNavigationBar(largeTitleColor: .white, backgoundColor: .blue, tintColor: .white, title: title, preferredLargeTitle: true)
            searchBar.barTintColor = .blue
        }
    }

    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = itemArray![indexPath.row]

        cell.textLabel?.text = item.title
        cell.backgroundColor = .green
        cell.textLabel?.textColor = .white
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }

    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let item = itemArray![indexPath.row]
        do {
            try realm.write{
                item.done = !item.done
            }
        } catch {
            print("Error saving done status, \(error)")
        }

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
                print("Error saving new items, \(error)")
            }
        }
        self.tableView.reloadData()
    }

    func read() {
        itemArray = (selectedCategory?.items.sorted(byKeyPath: "title", ascending: true))!
        tableView.reloadData()
    }

    func update(at indexPath: IndexPath, with element: Item) {
        let oldItem = itemArray![indexPath.row]
        do {
            try realm.write{
                oldItem.setValue(element.title, forKeyPath: "title")
                oldItem.setValue(element.done, forKeyPath: "done")
                oldItem.setValue(element.dateCreated, forKeyPath: "dateCreated")
            }
            tableView.reloadData()
        } catch {
            print("Error deleting item, \(error)")
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
            print("Error deleting item, \(error)")
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
