//
//  ColorLayer.swift
//  testMusic1
//
//  Created by Heltisace on 03.03.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit

class ColorLayer {
    func setLayer(view: UIView) {
        makeLayer(view: view, colors: [cgColorForRed(red: 209.0, green: 0.0, blue: 0.0),
                                           cgColorForRed(red: 255.0, green: 102.0, blue: 34.0),
                                           cgColorForRed(red: 255.0, green: 218.0, blue: 33.0),
                                           cgColorForRed(red: 51.0, green: 221.0, blue: 0.0),
                                           cgColorForRed(red: 17.0, green: 51.0, blue: 204.0),
                                           cgColorForRed(red: 34.0, green: 0.0, blue: 102.0),
                                           cgColorForRed(red: 51.0, green: 0.0, blue: 68.0)])
    }
    
    func topLightBlue(view: UIView) {
        makeLayer(view: view, colors: [getCgColor(red: 0.9, green: 0.77, blue: 1.00104),
                                           getCgColor(red: 0.35, green: 0.735901, blue: 1.00104)])
    }
    
    func bothSideLightBlue(view: UIView) {
        makeLayer(view: view, colors: [getCgColor(red: 0.9, green: 0.77, blue: 1.00104),
                                           getCgColor(red: 0.35, green: 0.735901, blue: 1.00104),
                                           getCgColor(red: 0.9, green: 0.77, blue: 1.00104)])
    }
    
    func bottomLightBlue(view: UIView) {
        makeLayer(view: view, colors: [getCgColor(red: 0.35, green: 0.735901, blue: 1.00104),
                                           getCgColor(red: 0.9, green: 0.77, blue: 1.00104)])
    }
    
    func orangeLayer(view: UIView) {
        makeLayer(view: view, colors: [getCgColor(red: 0.927496, green: 0.662351, blue: 0.275431),
                                       getCgColor(red: 0.927496, green: 0.662351, blue: 0.7)])
    }
    
    func grayLayer(view: UIView) {
        makeLayer(view: view, colors: [getCgColor(red: 0.754069, green: 0.754087, blue: 0.754077),
                                       getCgColor(red: 0.3, green: 0.3, blue: 0.3)])
    }
    
    func cgColorForRed(red: CGFloat, green: CGFloat, blue: CGFloat) -> AnyObject {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0).cgColor as AnyObject
    }
    
    func getCgColor(red: Float, green: Float, blue: Float) -> AnyObject {
        return UIColor(colorLiteralRed: red, green: green, blue: blue, alpha: 1.0).cgColor as AnyObject
    }
    
    private func makeLayer(view: UIView, colors: [Any]?) {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        
        gradientLayer.colors = colors
        
        let width = view.bounds.size.width
        let height = view.bounds.size.height
        let x = view.bounds.origin.x
        let y = view.bounds.origin.y
        
        gradientLayer.frame = CGRect(x: x, y: y, width: width, height: height)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
