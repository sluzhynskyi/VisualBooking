//
//  EncodableExtensions.swift
//  VisualBooking
//
//  Created by Danylo Sluzhynskyi on 11.12.2020.
//

import Foundation

enum JsonError: Error {
    case encodingError
    case identificationError
}



extension Encodable {
    func toJson(excluding keys: [String] = [String]()) throws -> [String: Any] {
        let objectData = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: objectData, options: [])
        guard var json = jsonObject as? [String: Any] else { throw JsonError.encodingError }
        for key in keys {
            json[key] = nil
        }
        return json
    }
}
