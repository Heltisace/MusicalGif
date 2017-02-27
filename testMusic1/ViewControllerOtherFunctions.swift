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
        OperationQueue().cancelAllOperations()
        DispatchQueue.global().sync{
            
            //Prepear for changing
            self.musicPrepear()
            self.theGif.isHidden = true
            self.closeSpinner(spinner: self.indicator)
            
            //Let's change
            self.animateGifChanging()
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
            self.indicator = self.spinner.showActivityIndicator(gifView: self.theGif, gifContainer: self.gifView)
        }
    }
    
    //Close the spinner
    func closeSpinner(spinner: NVActivityIndicatorView?){
        DispatchQueue.global().async{
            if self.indicator?.isAnimating == true{
                self.spinner.hideActivityIndicator(spinner: self.indicator!, gifContainer: self.gifView, gifView: self.theGif)
            }
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
                self.closeSpinner(spinner: self.indicator)
            })
            
            //Creating stream for synch
            queue.addOperations([synchOperation], waitUntilFinished: false)
        }
    }
}
