//
//  TimeSlider.swift
//  VisualBooking
//
//  Created by Danylo Sluzhynskyi on 12.12.2020.
//

import Foundation
import MultiSlider
class TimeSlider: MultiSlider {
    override func updateValueLabel(_ i: Int) {
        let labelValue: CGFloat
        if isValueLabelRelative {
            labelValue = i > 0 ? value[i] - value[i - 1]: value[i] - minimumValue
        } else {
            labelValue = value[i]
        }
        let sliderValue = valueLabelFormatter.string(from: NSNumber(value: Double(labelValue)))!
        let hours = (Int(Constants.openTime) + Int(sliderValue)!) / 60
        let minutes = String(format: "%02d", (Int(Constants.openTime) + Int(sliderValue)!) % 60)
        valueLabels[i].text = "\(hours):\(minutes)"
    }
}
