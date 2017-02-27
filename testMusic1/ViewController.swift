//
//  ViewController.swift
//  testMusic1
//
//  Created by Heltisace on 20.02.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView

class ViewController: UIViewController {
    
    //UI variables
    @IBOutlet weak var theGif: FLAnimatedImageView!
    @IBOutlet weak var songInfoLabel: UILabel!
    @IBOutlet weak var gifView: UIView!
    
    @IBOutlet weak var gifLeading: NSLayoutConstraint!
    @IBOutlet weak var gifBottom: NSLayoutConstraint!
    @IBOutlet weak var gifTrailing: NSLayoutConstraint!
    @IBOutlet weak var gifTop: NSLayoutConstraint!
    
    //Helpers variables
    let musicEngine = MusicEngine()
    let randomSongEngine = RandomSong()
    let randomGifEngine = RandomGif()
    let spinner = Spinner()
    
    //Global variables
    var indicator: NVActivityIndicatorView?
    var shouldChangeGif = false
    var viewWidth: CGFloat = 0.0
    var viewHeight: CGFloat = 0.0
    
    var normalGifRight: CGFloat = 0.0
    var normalGifBottom: CGFloat = 0.0
    var normalGifLeft: CGFloat = 0.0
    var normalGifTop: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //swipeControll
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.view.addGestureRecognizer(gestureRecognizer)
        
        viewWidth = self.view.frame.size.width
        viewHeight = self.view.frame.size.height
        
        normalGifRight = self.gifTrailing.constant
        normalGifBottom = self.gifBottom.constant
        normalGifLeft = self.gifLeading.constant
        normalGifTop = self.gifTop.constant
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "black_texture")!)
        
        startTheShow()
    }
    
    //Should show another gif?
    func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        //Counting moving
        let velocity = gestureRecognizer.velocity(in: self.view)
        var deltaX = velocity.x / 30
        
        if (self.gifTrailing.constant - deltaX) < self.normalGifRight{
            deltaX = 0
        }
        
        let newRightSpace = self.gifTrailing.constant - deltaX
        let newLeftSpace = self.gifLeading.constant + deltaX
        
        //Is swipe changed or ended
        if gestureRecognizer.state == .changed {
            self.gifTrailing.constant = newRightSpace
            self.gifLeading.constant = newLeftSpace
            self.view.layoutIfNeeded()
        } else if gestureRecognizer.state == .ended {
            self.shouldChangeGif = abs(self.gifTrailing.constant) > (self.viewWidth / 1.5)
            
            //Change or no
            if shouldChangeGif{
                self.startTheShow()
            }else{
                self.animateGifNotChanging()
            }
        }
    }
}

//Some functions
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
    
    //Animations to change the gif
    func animateGifChanging(){
        DispatchQueue.global().sync{
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.songInfoLabel.alpha = 0
                self.gifTrailing.constant = self.viewWidth
                self.gifLeading.constant = self.viewWidth
                
                self.view.layoutIfNeeded()
            })
        
            self.gifTrailing.constant = self.normalGifRight
            self.gifLeading.constant = self.normalGifLeft
            self.gifBottom.constant = self.viewHeight
            self.gifTop.constant = -self.viewHeight
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 1.0, delay: 1.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.gifBottom.constant = self.normalGifBottom
                self.gifTop.constant = self.normalGifTop
                
                self.view.layoutIfNeeded()
            })
            
            UIView.animate(withDuration: 1.0, delay: 1.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.songInfoLabel.alpha = 1
                
                self.view.layoutIfNeeded()
            })
        }
    }

    //If we don't change gif
    func animateGifNotChanging(){
        DispatchQueue.main.async{
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.gifTrailing.constant = self.normalGifRight
                self.gifLeading.constant = self.normalGifLeft
                
                self.view.layoutIfNeeded()
            })
        }
    }
}
