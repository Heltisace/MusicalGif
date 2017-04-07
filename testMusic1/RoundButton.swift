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
        let lightBlue = UIColor(colorLiteralRed: 52 / 255, green: 152 / 255, blue: 219 / 255, alpha: 1)
        let darkBlue = UIColor(colorLiteralRed: 40 / 255, green: 110 / 255, blue: 180 / 255, alpha: 1)
        
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
    func makeTheButtonRed() {
        let red = UIColor(colorLiteralRed: 255 / 255, green: 43 / 255, blue: 43 / 255, alpha: 1)
        let darkRed = UIColor(colorLiteralRed: 148 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1)
        
        self.disabledColors = .init(button: red, shadow: darkRed)
        self.colors = .init(button: red, shadow: darkRed)
        self.backgroundColor = red
    }
    func makeTheButtonGreen() {
        let green = UIColor(colorLiteralRed: 135 / 255, green: 240 / 255, blue: 0 / 255, alpha: 1)
        let darkGreen = UIColor(colorLiteralRed: 77 / 255, green: 153 / 255, blue: 0 / 255, alpha: 1)
        
        self.disabledColors = .init(button: green, shadow: darkGreen)
        self.colors = .init(button: green, shadow: darkGreen)
        self.backgroundColor = green
    }
}
