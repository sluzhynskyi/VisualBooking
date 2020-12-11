//
//  SnapshotExtensions.swift
//  VisualBooking
//
//  Created by Danylo Sluzhynskyi on 11.12.2020.
//

import Foundation
import FirebaseFirestore

extension DocumentSnapshot {
    func decode<T: Decodable>(as objectType: T.Type, includingId: Bool = true) throws -> T {
        var documentJson = data()
        if includingId {
            documentJson!["id"] = documentID
        }
        let documentData = try JSONSerialization.data(withJSONObject: documentJson, options: [])
        let decodedObject = try JSONDecoder().decode(objectType, from: documentData)
        return decodedObject
    }
}
