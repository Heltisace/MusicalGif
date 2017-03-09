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
        DispatchQueue.global().sync{
            
            //Prepear for changing
            doChangeOperation = false
            gestureRecognizer.removeTarget(self, action: #selector(handlePan))
            
            self.musicPrepear()
            self.loadSpinner()
            self.stopPreviousGif()
            
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
    
    func stopPreviousGif(){
        if operations.count != 0{
            self.operations[0].cancel()
            self.operations.removeFirst()
        }
    }
    
    //Adds spinner animation
    func loadSpinner(){
        self.closeSpinner(spinner: self.indicator)
        DispatchQueue.global().sync{
            self.indicator = self.spinner.showActivityIndicator(gifView: self.theGif, gifContainer: self.viewInGifView)
        }
    }
    
    //Close the spinner
    func closeSpinner(spinner: NVActivityIndicatorView?){
        DispatchQueue.global().sync{
            if self.indicator?.isAnimating == true{
                self.spinner.hideActivityIndicator(spinner: self.indicator!, gifContainer: self.viewInGifView, gifView: self.theGif)
            }
        }
    }
    
    //Load a new song
    func generateNewSong(){
        DispatchQueue.global().sync {
            songURL = self.randomSongEngine.generateRandomSong(musicEngine: self.musicEngine, randomSongEngine: self.randomSongEngine, infoLabel: self.songInfoLabel)
            self.openSongButton.isEnabled = true
        }
    }
    
    func loadNewSong(){
        DispatchQueue.global().sync {
            self.randomSongEngine.loadRandomSong(musicEngine: self.musicEngine)
        }
    }
    
    func loadSongInfo(){
        DispatchQueue.global().sync {
            self.randomSongEngine.loadSongInfo(infoLabel: self.songInfoLabel)
        }
    }
    
    //Show image and play music if image is loaded
    func startMusicAndGif(){
        DispatchQueue.global().sync{
            doChangeOperation = true
            
            let synchOperation = ConcurrentOperation()
            operations.append(synchOperation)
            let randomTag = self.randomGifEngine.randomTag()
            gifURL = randomGifEngine.getGifWithTag(tag: randomTag)
            
            openGifButton.isEnabled = true
            theGif.sd_cancelCurrentImageLoad()
            
            operations[0].synch(closure: self.theGif.sd_setImage(with: URL(string: self.gifURL)) { (image, error, cacheType, imageURL) in
                if self.doChangeOperation{
                    self.musicEngine.playTrack()
                    self.closeSpinner(spinner: self.indicator)
                }
            })
            
            //Creating stream for synch
            queue.addOperations([operations[0]], waitUntilFinished: false)
        }
    }
}
