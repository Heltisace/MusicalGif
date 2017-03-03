//
//  loadingGif.swift
//  testMusic1
//
//  Created by Heltisace on 25.02.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView

class Spinner{
    
    //Spinner
    
    func showActivityIndicator(gifView: FLAnimatedImageView, gifContainer: UIView) ->  NVActivityIndicatorView{
        let loadingView = RoundView()
        let spinner = NVActivityIndicatorView(frame: CGRect(), type: NVActivityIndicatorType(rawValue: 5), color: self.getRandomColor())
        
        
        DispatchQueue.main.async {
            gifView.isHidden = true
            loadingView.frame = gifView.frame
            loadingView.backgroundColor = .white
            
            spinner.frame = CGRect(x: 0, y: 0, width: loadingView.frame.size.width / 2, height: loadingView.frame.size.height / 2)
            spinner.center = CGPoint(x:loadingView.bounds.size.width / 2, y:loadingView.bounds.size.height / 2)
            
            loadingView.addSubview(spinner)
            gifContainer.addSubview(loadingView)
            gifContainer.isHidden = false
            spinner.startAnimating()
        }
        return spinner
    }
    
    func hideActivityIndicator(spinner: NVActivityIndicatorView, gifContainer: UIView,gifView: FLAnimatedImageView) {
        DispatchQueue.main.async {
            spinner.stopAnimating()
            spinner.superview?.removeFromSuperview()
            
            gifView.isHidden = false
        }
    }
    
    func getRandomColor() -> UIColor{
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}
