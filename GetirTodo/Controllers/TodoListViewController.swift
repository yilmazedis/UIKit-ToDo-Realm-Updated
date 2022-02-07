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

    //MARK: - Update Action -
    @objc func longPressToUpdate(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                alertControllerView(act: ActionType.Update) { [weak self] (text) in
                    guard let self = self else {
                        Logger.log(what: K.ErrorMessage.weakSelfWarning, about: .error)
                        return

                    }
                    
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
        alertControllerView(act: ActionType.Add) { [weak self] (text) in
            guard let self = self else {
                Logger.log(what: K.ErrorMessage.weakSelfWarning, about: .error)
                return

            }

            let newItem = Item()
            newItem.title = text
            newItem.dateCreated = Date()
            self.create(element: newItem)
        }
    }
}
