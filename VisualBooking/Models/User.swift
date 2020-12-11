//
//  User.swift
//  VisualBooking
//
//  Created by Danylo Sluzhynskyi on 11.12.2020.
//

import Foundation

struct User: Codable, FirebaseObject {
    var id: String? = nil
    var name: String
    var phone: String
    init(name: String, phone: String){
        self.name = name
        self.phone = phone
    }
}
