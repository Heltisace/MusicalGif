//
//  ViewControllerInitialization.swift
//  testMusic1
//
//  Created by Heltisace on 03.03.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit

extension ViewController{
    func initialization(){
        DispatchQueue.global().sync{
            viewWidth = self.view.frame.size.width
            viewHeight = self.view.frame.size.height
            gifViewWidth = gifView.frame.size.width
            
            normalGifRight = self.gifTrailing.constant
            normalGifBottom = self.gifBottom.constant
            normalGifLeft = self.gifLeading.constant
            normalGifTop = self.gifTop.constant
            normalLeftButton = self.openSongLeading.constant
            normalRightButton = self.openGifTrailing.constant
            normalBetweenButtons = self.betweenButtons.constant
            
            colorLayer.setLayer(someView: gifView)
        }
    }
}
