//
//  Constants.swift
//  GetirTodo
//
//  Created by Yilmaz Edis (employee ID: y84185251) on 6.02.2022.
//

import Foundation
import SwiftUI

struct K {
    struct Item {
        static let title = "title"
        static let done = "done"
        static let dateCreated = "dateCreated"
    }

    struct Category {
        static let name = "name"
    }

    struct Alert {
        static let cancel = "Cancel"
        static let placeHolder = "Descript with a short title"
    }

    struct ErrorMessage {
        static let create = "Error while creating element"
        static let read = "Error while reading element"
        static let update = "Error while updating element"
        static let delete = "Error while deleting element"

        static let initialisingRealm = "Error initialising new realm"
    }

    struct InfoMessages {
        static let initialisingRealm = "Binding to Realm is successful"
    }

    struct SearchBar {
        static let filter = "title CONTAINS[cd] %@"
        static let keyPath = "dateCreated"
        static let ascending = true
    }

    static let cell = "Cell"
    static let rowHeight = 80.0
    static let appName = "GetirTodo"
    static let goToItems = "goToItems"
    static let dateFormat = "yyyy-MM-dd HH:mm:ss"
}
