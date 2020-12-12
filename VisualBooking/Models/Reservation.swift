//
//  Reservation.swift
//  VisualBooking
//
//  Created by Danylo Sluzhynskyi on 11.12.2020.
//

import Foundation
struct Reservation: Codable, FirebaseObject {
    var id: String? = nil
    var startReservation: Float
    var endReservation: Float
    var userId: String
    var tableId: String
    init(userId: String, tableId: String, startReservation: Date, endReservation: Date) {
        self.userId = userId
        self.tableId = tableId
        self.startReservation = Float(startReservation.timeIntervalSince1970)
        self.endReservation = Float(endReservation.timeIntervalSince1970)
    }
}

