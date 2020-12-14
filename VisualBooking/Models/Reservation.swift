//
//  Reservation.swift
//  VisualBooking
//
//  Created by Danylo Sluzhynskyi on 11.12.2020.
//

import Foundation
struct Reservation: Codable, FirebaseObject {
    var id: String? = nil
    var startReservation: TimeInterval
    var endReservation: TimeInterval
    var userId: String
    var tableId: String
    init(userId: String, tableId: String, startReservation: Date, endReservation: Date) {
        self.userId = userId
        self.tableId = tableId
        self.startReservation = startReservation.timeIntervalSince1970
        self.endReservation = endReservation.timeIntervalSince1970
    }
}

//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd HH:mm"
//        let st = formatter.date(from: "2020/12/12 18:30")!
//        let end = formatter.date(from: "2020/12/12 19:30")!
//        let DanyloId = "vP2s62SjcTq3FOVaKhDE"
//
//        let r1 = Reservation(userId: DanyloId, tableId: "1", startReservation: st, endReservation: end)
//        FIRFirestoreService.shared.create(for: r1, in: .reservations)
//        print("LOADED")
