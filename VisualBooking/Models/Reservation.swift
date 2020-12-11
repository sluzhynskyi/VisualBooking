//
//  Reservation.swift
//  VisualBooking
//
//  Created by Danylo Sluzhynskyi on 11.12.2020.
//

import Foundation
struct Reservation: Codable, FirebaseObject {
    var id: String? = nil
    var startReservation: Date
    var endReservation: Date
    var userId: String
    var tableId: String
}

