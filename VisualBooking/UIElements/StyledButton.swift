//
//  StyledButton.swift
//  VisualBooking
//
//  Created by Danylo Sluzhynskyi on 17.12.2020.
//

import UIKit

class StyledButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setStyle()
    }
    private func setStyle() {
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = Constants.backgroundColor
        self.layer.borderColor = Constants.borderColor
        self.layer.borderWidth = 0.25
        self.titleLabel!.font = UIFont(name: "Print Clearly", size: 30)
    }
}
