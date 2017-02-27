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
}
