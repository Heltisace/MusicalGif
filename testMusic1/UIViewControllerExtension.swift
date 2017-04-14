//
//  UIViewControllerExtension.swift
//  testMusic1
//
//  Created by Heltisace on 14.04.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit

extension UIViewController {
    func createAlert(error:String) -> UIAlertController{
        let alertController = UIAlertController(title:
            "Error", message: error, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
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
