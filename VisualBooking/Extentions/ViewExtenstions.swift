//
//  ViewExtenstions.swift
//  VisualBooking
//
//  Created by Danylo Sluzhynskyi on 13.12.2020.
//

import Foundation
import UIKit
@propertyWrapper
public struct UsesAutoLayout<T: UIView> {
    public var wrappedValue: T {
        didSet {
            wrappedValue.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
    }
}
extension UIView {

    func addCorners() {
        clipsToBounds = true
        layer.masksToBounds = false
        layer.cornerRadius = 20
    }
    func addShadow() {
        layer.shadowColor = Constants.shadowColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 0.5
    }
}
