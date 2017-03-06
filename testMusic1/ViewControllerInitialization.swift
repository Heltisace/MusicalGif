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
            
            let lightBlue = UIColor(colorLiteralRed: 52 / 255, green: 152 / 255, blue: 219 / 255, alpha: 1)
            let darkBlue = UIColor(colorLiteralRed: 30 / 255, green: 110 / 255, blue: 170 / 255, alpha: 1)
            
            openGifButton.backgroundColor = lightBlue
            openSongButton.backgroundColor = lightBlue
            
            openGifButton.disabledColors = .init(button: lightBlue, shadow: darkBlue)
            openSongButton.disabledColors = .init(button: lightBlue, shadow: darkBlue)
            openSongButton.colors = .init(button: lightBlue, shadow: darkBlue)
            openGifButton.colors = .init(button: lightBlue, shadow: darkBlue)
        }
    }
}
