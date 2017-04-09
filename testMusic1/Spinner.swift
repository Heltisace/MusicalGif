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

class Spinner {
    //Spinner
    func showActivityIndicator(gifView: FLAnimatedImageView, gifContainer: UIView) -> NVActivityIndicatorView {
        let spinner = NVActivityIndicatorView(frame: CGRect(), type:
            NVActivityIndicatorType(rawValue: 6), color: self.getRandomColor())

        DispatchQueue.main.async {
            gifView.isHidden = true
            spinner.frame = CGRect(x: 0, y: 0, width:
                gifContainer.frame.size.width / 2, height: gifContainer.frame.size.height / 2)
            spinner.center = CGPoint(x:gifContainer.bounds.size.width / 2, y:gifContainer.bounds.size.height / 2)

            gifContainer.addSubview(spinner)
            spinner.startAnimating()
        }
        return spinner
    }
    func hideActivityIndicator(spinner: NVActivityIndicatorView, gifContainer: UIView, gifView: FLAnimatedImageView) {
        DispatchQueue.main.async {
            spinner.stopAnimating()
            spinner.removeFromSuperview()

            gifView.isHidden = false
        }
    }

    func getRandomColor() -> UIColor {
        let randomRed = CGFloat(drand48())
        let randomGreen = CGFloat(drand48())
        let randomBlue = CGFloat(drand48())

        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}
