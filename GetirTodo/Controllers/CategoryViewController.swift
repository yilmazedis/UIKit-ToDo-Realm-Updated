//
//  CategoryViewController.swift
//  GetirTodo
//
//  Created by Yilmaz Edis (employee ID: y84185251) on 5.02.2022.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    //MARK: - Constants
    let realm = try! Realm()

    //MARK: - Variables
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = K.rowHeight

        // Retrieve elements from Category
        read()

        // Adding longpress gesture to update elements
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressToUpdate))
        tableView.addGestureRecognizer(longPress)
    }

    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar(largeTitleColor: .white, backgoundColor: .systemBlue, tintColor: .white, title: K.appName, preferredLargeTitle: true)
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: K.cell, for: indexPath)
        cell.textLabel?.text = categories![indexPath.row].name
        cell.backgroundColor = .systemGreen
        cell.textLabel?.textColor = .white

        return cell
    }

    //MARK: - TableView Delegate Methods -
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.goToItems, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController

        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories![indexPath.row]
        }
    }

    //MARK: - Delete side
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delete(at: indexPath)
        }
    }

    //MARK: - Update Action -
    @objc func longPressToUpdate(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                // your code here, get the row for the indexPath or do whatever you want
                alertControllerView(act: ActionType.Update) { [weak self] (name) in
                    guard let self = self else {
                        Logger.log(what: K.ErrorMessage.weakSelfWarning, about: .error)
                        return

                    }
                    
                    let newCategory = Category()
                    newCategory.name = name
                    self.update(at: indexPath, with: newCategory)
                }
            }
        }
    }

    //MARK: - Add Action -
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        alertControllerView(act: ActionType.Add) { [weak self] (text) in
            guard let self = self else {
                Logger.log(what: K.ErrorMessage.weakSelfWarning, about: .error)
                return

            }

            let newCategory = Category()
            newCategory.name = text
            self.create(element: newCategory)
        }
    }
}
