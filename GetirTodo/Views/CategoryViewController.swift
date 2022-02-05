//
//  CategoryViewController.swift
//  GetirTodo
//
//  Created by Yilmaz Edis (employee ID: y84185251) on 5.02.2022.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()

    // Potential namespace clash with OpaquePointer (same name of Category)
    // Use correct type from dropdown or add backticks to fix e.g., var categories = [`Category`]()
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressToUpdate))
        tableView.addGestureRecognizer(longPress)

    }

    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar(largeTitleColor: .white, backgoundColor: .blue, tintColor: .white, title: "Todo", preferredLargeTitle: true)
    }

    //MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categories!.count

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = categories![indexPath.row].name
        cell.backgroundColor = .green
        cell.textLabel?.textColor = .white

        return cell

    }

    //MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController

        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories![indexPath.row]
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteModel(at: indexPath)
        }
    }

    //MARK: - Data Manipulation Methods

    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }

    func loadCategories() {

        categories = realm.objects(Category.self)
        tableView.reloadData()
    }

    //MARK: - Update Data
    func updateModel(at indexPath: IndexPath, with name: String) {
        let oldCategory = categories![indexPath.row]
        do {
            try realm.write{
                oldCategory.setValue(name, forKeyPath: "name")
            }
            tableView.reloadData()
        } catch {
            print("Error deleting category, \(error)")
        }
    }

    //MARK: - Delete Data from model
    func deleteModel(at indexPath: IndexPath) {
        let categoryForDeletion = self.categories![indexPath.row]
        do {
            try self.realm.write {
                self.realm.delete(categoryForDeletion)
            }
            tableView.reloadData()
        } catch {
            print("Error deleting category, \(error)")
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
                let alert = UIAlertController(title: "Update category", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "Update", style: .default) { (action) in
                    //what will happen once the user clicks the Add Item button on our UIAlert
                    let name: String = textField.text!
                    self.updateModel(at: indexPath, with: name)
                }

                alert.addTextField { (alertTextField) in
                    alertTextField.placeholder = "Create new category name"
                    textField = alertTextField
                }

                alert.addAction(action)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add", style: .default) { (action) in

            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
        }

        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }

        present(alert, animated: true, completion: nil)
    }
}
