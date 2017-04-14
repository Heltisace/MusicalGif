//
//  UIViewControllerExtension.swift
//  testMusic1
//
//  Created by Heltisace on 14.04.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit

extension UIViewController {
    func createAlert(title: String, message: String, button: String, action: (() -> Void)?) -> UIAlertController {
        let alertController = UIAlertController(title:
            title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: button, style: .cancel, handler: { (_: UIAlertAction!) in
            action?()
        })
        alertController.addAction(defaultAction)
        
        return alertController
    }
    func makeShadow(view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 5
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
    }
    func setBackgroundAlpha(view: UIView, alpha: CGFloat) {
        view.backgroundColor = view.backgroundColor?.withAlphaComponent(alpha)
    }
}
