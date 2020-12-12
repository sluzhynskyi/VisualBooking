//
//  TimeSlider.swift
//  VisualBooking
//
//  Created by Danylo Sluzhynskyi on 12.12.2020.
//

import Foundation
import MultiSlider
class TimeSlider: MultiSlider {
    func updateValueLabel(_ i: Int) {
        let labelValue: CGFloat
        if isValueLabelRelative {
            labelValue = i > 0 ? value[i] - value[i - 1]: value[i] - minimumValue
        } else {
            labelValue = value[i]
        }
        let sliderValue = valueLabelFormatter.string(from: NSNumber(value: Double(labelValue)))!
        let hours = (Int(sliderValue)!) / 60
        let minutes = String(format: "%02d", (Int(sliderValue)!) % 60)
        print("\(hours):\(minutes)")
        valueLabels[i].text = "\(hours):\(minutes)"
    }
}
