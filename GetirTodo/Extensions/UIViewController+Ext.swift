//
//  UIViewController+Ext.swift
//  GetirTodo
//
//  Created by Yilmaz Edis (employee ID: y84185251) on 6.02.2022.
//

import UIKit

extension UIViewController {
    func alertControllerView(act type: ActionType, with action: @escaping (_ text: String) -> Void) {
        var textField = UITextField()
        let alert = UIAlertController(title: type.rawValue, message: "", preferredStyle: .alert)
        let addButton = UIAlertAction(title: type.rawValue, style: .default) { _ in
            action(textField.text ?? "")
        }

        alert.addAction(addButton)
        alert.addAction(UIAlertAction(title: K.Alert.cancel, style: .cancel, handler: nil))
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = K.Alert.placeHolder
        }
        present(alert, animated: true, completion: nil)
    }
}
