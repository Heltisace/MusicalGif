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
    
    //Stop previous song
    func musicPrepear(){
        DispatchQueue.global().sync {
            self.musicEngine.stopPlaying()
        }
    }
    
    //Adds spinner animation
    func loadSpinner(){
        DispatchQueue.global().async{
            if self.indicator?.isAnimating == true{
                self.spinner.hideActivityIndicator(spinner: self.indicator!, gifContainer: self.gifView, gifView: self.theGif)
            }
            self.indicator = self.spinner.showActivityIndicator(gifView: self.theGif, gifContainer: self.gifView)
        }
    }
    
    //Load a new song
    func loadNewSong(){
        DispatchQueue.global().sync {
            self.randomSongEngine.loadRandomSong(musicEngine: self.musicEngine, randomSongEngine: self.randomSongEngine, infoLabel: self.songInfoLabel)
        }
    }
    
    //Show image and play music if image is loaded
    func startMusicAndGif(){
        DispatchQueue.global().sync{
            let queue = OperationQueue()
            
            let synchOperation = ConcurrentOperation()
            let gifURL = self.randomGifEngine.getRandomGif()
            
            synchOperation.synch(closure: self.theGif.sd_setImage(with: URL(string: gifURL)) { (image, error, cacheType, imageURL) in
                self.musicEngine.playTrack()
                synchOperation.state = .finished
                self.spinner.hideActivityIndicator(spinner: self.indicator!, gifContainer: self.gifView, gifView: self.theGif)
            })
            
            //Creating stream for synch
            queue.addOperations([synchOperation], waitUntilFinished: false)
        }
    }
    
    func startTheShow(){
        self.musicPrepear()
        
        DispatchQueue.global().async{
            self.theGif.isHidden = true
        }
        
        self.animateGifChanging()
        
        DispatchQueue.main.async{
            OperationQueue().cancelAllOperations()
            self.loadSpinner()
            self.loadNewSong()
            self.startMusicAndGif()
        }
    }
    
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
