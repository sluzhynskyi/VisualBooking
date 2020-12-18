//
//  Table.swift
//  VisualBooking
//
//  Created by Danylo Sluzhynskyi on 11.12.2020.
//

import Foundation
import Macaw
struct Table {
    var id: String!
    var peopleByTable: Int = Constants.defaultPeopleByTable
    var tableType: String? = TableType.regular.rawValue
    let node: Node
    init(id: String, node: Node) {
        self.id = id
        self.node = node
    }
}

enum TableType: String {
    case regular
    case withSofa
}
