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
