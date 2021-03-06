//
//  TodoListViewController+Ext.swift
//  GetirTodo
//
//  Created by Yilmaz Edis (employee ID: y84185251) on 6.02.2022.
//

import UIKit

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemArray = itemArray!.filter(K.SearchBar.filter, searchBar.text!).sorted(byKeyPath: K.SearchBar.keyPath, ascending: K.SearchBar.ascending)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            read()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
