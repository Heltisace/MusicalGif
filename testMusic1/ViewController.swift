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
        
        //Initialization
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
            self.setGifConstraints(left: newLeftSpace, right: newRightSpace, top: nil, bottom: nil)
            self.view.layoutIfNeeded()
        } else if gestureRecognizer.state == .ended {
            self.shouldChangeGif = abs(self.gifTrailing.constant) > (self.viewWidth / 1.5)
    
            //Change or no
            if shouldChangeGif{
                startTheShow()
            }else{
                self.animateGifNotChanging()
            }
        }
    }
}
