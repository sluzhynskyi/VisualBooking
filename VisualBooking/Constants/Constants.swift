//
//  Constants.swift
//  VisualBooking
//
//  Created by Danylo Sluzhynskyi on 12.12.2020.
//

import Foundation
import UIKit
import Macaw
struct Constants {
    // All time is in minutes
    static let openTime: CGFloat = 8 * 60
    static let closeTime: CGFloat = 20 * 60
    static let snapTime: CGFloat = 15
    static let minimalTimeReservation: CGFloat = 90

    static let thumbsInitialPosition: [CGFloat] = [openTime, closeTime]
    // Colors of slider
    static let inSlideColor: UIColor = UIColor(hex: "#fdaf47ff")! // #f3b96bff
    static let outSlideColor: UIColor = UIColor(hex: "#c6b8a7ff")!
    // Color of textView
    static let backgroundColor: UIColor = UIColor(hex: "#fdaf47ff")!
    static let borderColor: CGColor = UIColor(hex: "#f3b96bff")!.cgColor
    static let shadowColor: CGColor = UIColor(hex: "#463219ff")!.cgColor
    // Color of SVG
    static let tableColor: Color = Color(0x56595f)
    static let tableReservedColor: Color = Color.red
    static let defaultPeopleByTable: Int = 2
    // SVG filename
    static let svgFileName: String = "restaurant_croped"
    static let tableId = [
        "0",
        "1",
        "2",
        "3",
        "4",
        "5"
    ]
    // Placeholder for textfield
    static let placeholderDateField: String = "Pick a Day"
}
