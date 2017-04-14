//
//  CustomButton.swift
//  testMusic1
//
//  Created by Heltisace on 20.02.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit
import SwiftyButton

class RoundButton: PressableButton {
    func startSet() {
        let lightBlue = UIColor(colorLiteralRed: 0.2, green: 0.735901, blue: 1.00104, alpha: 1)
        let darkBlue = UIColor(colorLiteralRed: 0.1, green: 0.5, blue: 1.00104, alpha: 1)

        self.backgroundColor = lightBlue
        self.disabledColors = .init(button: lightBlue, shadow: darkBlue)
        self.colors = .init(button: lightBlue, shadow: darkBlue)
    }
    convenience init(type: PressableButton) {
        self.init(type: type)
        clipsToBounds = true
        startSet()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        clipsToBounds = true
        startSet()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        startSet()
    }
    override var clipsToBounds: Bool {
        didSet {
            layer.cornerRadius = 5
        }
    }
}
