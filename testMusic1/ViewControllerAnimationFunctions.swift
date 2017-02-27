//
//  ViewControllerFunctions.swift
//  testMusic1
//
//  Created by Heltisace on 27.02.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView

extension ViewController{
    
    //Operations with constraints
    func setGifConstraints(left: CGFloat?, right: CGFloat?, top: CGFloat?, bottom: CGFloat?){
        if left != nil{
            self.gifLeading.constant = left!
        }
        if top != nil{
            self.gifTop.constant = top!
        }
        if right != nil{
            self.gifTrailing.constant = right!
        }
        if bottom != nil{
            self.gifBottom.constant = bottom!
        }
    }
    //Animations if changing
    
    func animateGifChanging(){
        removeGifFromView()
        removeLabelFromView()
        
        sendGifFarAway()
        
        returnGifToView()
        returnLabelToView()
    }
    
    func removeLabelFromView(){
        DispatchQueue.global().sync{
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.songInfoLabel.alpha = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func removeGifFromView(){
        DispatchQueue.global().sync{
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.setGifConstraints(left: self.viewWidth, right: self.viewWidth, top: nil, bottom: nil)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func returnGifToView(){
        DispatchQueue.global().sync{
            UIView.animate(withDuration: 1.0, delay: 1.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.setGifConstraints(left: nil, right: nil, top: self.normalGifTop, bottom: self.normalGifBottom)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func returnLabelToView(){
        DispatchQueue.global().sync{
            UIView.animate(withDuration: 1.0, delay: 1.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.songInfoLabel.alpha = 1
                
                self.view.layoutIfNeeded()
            })
        }
    }
    func sendGifFarAway(){
        DispatchQueue.global().sync{
            self.setGifConstraints(left: self.normalGifLeft, right: self.normalGifRight, top: -self.viewHeight, bottom: self.viewHeight)
            self.view.layoutIfNeeded()
        }
    }
    
    //If we don't change gif
    func animateGifNotChanging(){
        DispatchQueue.main.async{
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.setGifConstraints(left: self.normalGifLeft, right: self.normalGifRight, top: nil, bottom: nil)
                self.view.layoutIfNeeded()
            })
        }
    }
}
