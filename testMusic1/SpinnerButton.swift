//
//  SpinnerButton.swift
//  testMusic1
//
//  Created by Heltisace on 08.04.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit

extension UIButton {
    func loadingIndicator() {
        let tag = 808404

        self.isEnabled = false
        self.setTitle("", for: .disabled)
        self.alpha = 0.5
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        let buttonHeight = self.bounds.size.height
        let buttonWidth = self.bounds.size.width
        indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
        indicator.tag = tag
        self.addSubview(indicator)
        indicator.startAnimating()
    }

    func closeIndicator() {
        let tag = 808404

        self.isEnabled = true
        self.alpha = 1.0
        if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
            indicator.stopAnimating()
            indicator.removeFromSuperview()
        }
    }
}
