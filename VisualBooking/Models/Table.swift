//
//  Table.swift
//  VisualBooking
//
//  Created by Danylo Sluzhynskyi on 11.12.2020.
//

import Foundation

struct Table: Codable, FirebaseObject {
    var id: String? = nil
    var peopleByTable: Int = 2
    var tableType: String? = nil
    init(peopleByTable: Int, tableType: TableType) {
        self.peopleByTable = peopleByTable
        self.tableType = tableType.rawValue
    }
}

enum TableType: String {
    case regular
    case withSofa
}
