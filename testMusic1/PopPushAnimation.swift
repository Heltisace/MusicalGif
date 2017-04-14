//
//  RoundLabel.swift
//  testMusic1
//
//  Created by Heltisace on 23.02.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit

extension UINavigationController {
    func popPushAnimation(navigation: UINavigationController) {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade
            navigation.view.layer.add(transition, forKey: nil)
        })
    }
}
