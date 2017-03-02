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
    @IBOutlet weak var openSongButton: UIButton!
    @IBOutlet weak var openGifButton: UIButton!
    
    
    @IBOutlet weak var gifLeading: NSLayoutConstraint!
    @IBOutlet weak var gifBottom: NSLayoutConstraint!
    @IBOutlet weak var gifTrailing: NSLayoutConstraint!
    @IBOutlet weak var gifTop: NSLayoutConstraint!
    @IBOutlet weak var openGifTrailing: NSLayoutConstraint!
    @IBOutlet weak var openSongLeading: NSLayoutConstraint!
    @IBOutlet weak var betweenButtons: NSLayoutConstraint!
    
    //Helpers variables
    let musicEngine = MusicEngine()
    let randomSongEngine = RandomSong()
    let randomGifEngine = RandomGif()
    let spinner = Spinner()
    
    //Global variables
    var indicator: NVActivityIndicatorView?
    var shouldChangeGif = false
    var gifURL = ""
    var songURL = ""
    
    let queue = OperationQueue()
    var operations: [ConcurrentOperation] = []
    
    var viewWidth: CGFloat = 0.0
    var viewHeight: CGFloat = 0.0
    var gifViewWidth: CGFloat = 0.0
    
    var normalGifRight: CGFloat = 0.0
    var normalGifBottom: CGFloat = 0.0
    var normalGifLeft: CGFloat = 0.0
    var normalGifTop: CGFloat = 0.0
    
    var normalLeftButton: CGFloat = 0.0
    var normalRightButton: CGFloat = 0.0
    var normalBetweenButtons: CGFloat = 0.0
    
    var lastDegree: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //swipeControll
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.gifView.addGestureRecognizer(gestureRecognizer)
        
        //Initialization
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "black_texture")!)
        
        startTheShow()
    }
    
    //Should show another gif?
    func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        //Counting moving
        let velocity = gestureRecognizer.velocity(in: self.theGif)
        var deltaX = velocity.x / 30
        
        if (self.gifTrailing.constant - deltaX) < self.normalGifRight{
            deltaX = 0
        }
        
        //Gif way
        let newRightSpace = self.gifTrailing.constant - deltaX
        let newLeftSpace = self.gifLeading.constant + deltaX
        
        //Rotate gif
        let degreeCoef = self.gifViewWidth / 90
        var newDegree = newLeftSpace / degreeCoef
        if -newDegree > 45.0{
            newDegree = lastDegree
        }
        
        //Is swipe changed or ended
        if gestureRecognizer.state == .changed {
            setGifConstraints(left: newLeftSpace, right: newRightSpace, top: nil, bottom: nil)
            self.gifView.transform = CGAffineTransform(rotationAngle: (newDegree * CGFloat(M_PI)) / 180.0)
            lastDegree = newDegree
            self.view.layoutIfNeeded()
        } else if gestureRecognizer.state == .ended {
            self.shouldChangeGif = abs(self.gifTrailing.constant) > (self.gifViewWidth / 2)
    
            //Change or no
            if shouldChangeGif{
                startTheShow()
            }else{
                animateGifNotChanging()
            }
        }
    }
    @IBAction func openSong(_ sender: UIButton) {
        UIApplication.shared.openURL(NSURL(string: songURL) as! URL)
    }
    
    @IBAction func openGif(_ sender: UIButton) {
        UIApplication.shared.openURL(NSURL(string: gifURL) as! URL)
    }
    
}
