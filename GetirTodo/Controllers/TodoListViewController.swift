//
//  TodoListViewController.swift
//  GetirTodo
//
//  Created by Yilmaz Edis (employee ID: y84185251) on 5.02.2022.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {


    @IBOutlet weak var searchBar: UISearchBar!

    var itemArray: Results<Item>?
    let realm = try! Realm()

    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
            deleteModel(at: indexPath)
        }
    }

    //MARK: - Update New Items
    @objc func longPressToUpdate(sender: UILongPressGestureRecognizer) {

        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                // your code here, get the row for the indexPath or do whatever you want
                print("Long press Pressed:)")

                var textField = UITextField()
                let alert = UIAlertController(title: "Update Item", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "Update", style: .default) { (action) in
                    //what will happen once the user clicks the Add Item button on our UIAlert

                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()

                    self.updateModel(at: indexPath, with: newItem)
                }

                alert.addTextField { (alertTextField) in
                    alertTextField.placeholder = "Create new item"
                    textField = alertTextField
                }

                alert.addAction(action)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }

    //MARK: - Add New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }

        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    //MARK - Model Manupulation Methods

    func loadItems() {

        itemArray = (selectedCategory?.items.sorted(byKeyPath: "title", ascending: true))!
        tableView.reloadData()

    }

    func updateModel(at indexPath: IndexPath, with newItem: Item) {
        let oldItem = itemArray![indexPath.row]
        do {
            try realm.write{
                oldItem.setValue(newItem.title, forKeyPath: "title")
                oldItem.setValue(newItem.done, forKeyPath: "done")
                oldItem.setValue(newItem.dateCreated, forKeyPath: "dateCreated")
            }
            tableView.reloadData()
        } catch {
            print("Error deleting item, \(error)")
        }
    }

    //Mark: - Delete Data from Swipe
    func deleteModel(at indexPath: IndexPath) {
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

}

//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemArray = itemArray!.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}
