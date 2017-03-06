//
//  ColorLayer.swift
//  testMusic1
//
//  Created by Heltisace on 03.03.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit

class ColorLayer{
    func setLayer(someView: UIView){
        let gradientLayer = CAGradientLayer()
        let width = someView.bounds.size.width
        let height = someView.bounds.size.height
        let x = someView.bounds.origin.x
        let y = someView.bounds.origin.y
        gradientLayer.frame = CGRect(x: x, y: y, width: width, height: height)
        gradientLayer.colors = [cgColorForRed(red: 209.0, green: 0.0, blue: 0.0),
                                cgColorForRed(red: 255.0, green: 102.0, blue: 34.0),
                                cgColorForRed(red: 255.0, green: 218.0, blue: 33.0),
                                cgColorForRed(red: 51.0, green: 221.0, blue: 0.0),
                                cgColorForRed(red: 17.0, green: 51.0, blue: 204.0),
                                cgColorForRed(red: 34.0, green: 0.0, blue: 102.0),
                                cgColorForRed(red: 51.0, green: 0.0, blue: 68.0)]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        someView.layer.insertSublayer(gradientLayer, at: 0)
    }
    func cgColorForRed(red: CGFloat, green: CGFloat, blue: CGFloat) -> AnyObject {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0).cgColor as AnyObject
    }
}
