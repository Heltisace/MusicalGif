//
//  CustomButton.swift
//  testMusic1
//
//  Created by Heltisace on 20.02.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import Foundation
import UIKit
import SwiftyButton

class RoundButton: PressableButton {
    func startSet() {
        let lightBlue = UIColor(colorLiteralRed: 52 / 255, green: 152 / 255, blue: 219 / 255, alpha: 1)
        let darkBlue = UIColor(colorLiteralRed: 30 / 255, green: 110 / 255, blue: 170 / 255, alpha: 1)
        
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
            layer.cornerRadius = 10
        }
    }
}
