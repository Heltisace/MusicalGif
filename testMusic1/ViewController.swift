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
import SwiftyButton
import Firebase
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {

    //UI variables
    @IBOutlet weak var theGif: FLAnimatedImageView!
    @IBOutlet weak var songInfoLabel: UILabel!
    @IBOutlet weak var gifView: UIView!
    @IBOutlet weak var insideGifView: UIView!
    @IBOutlet weak var openSongButton: RoundButton!
    @IBOutlet weak var openGifButton: RoundButton!
    @IBOutlet weak var viewInGifView: UIView!
    @IBOutlet weak var songInfoView: UIView!
    @IBOutlet weak var likeTheSet: UIBarButtonItem!

    //Gif Constraintns
    @IBOutlet weak var gifLeading: NSLayoutConstraint!
    @IBOutlet weak var gifBottom: NSLayoutConstraint!
    @IBOutlet weak var gifTrailing: NSLayoutConstraint!
    @IBOutlet weak var gifTop: NSLayoutConstraint!
    @IBOutlet weak var insideGifTop: NSLayoutConstraint!
    @IBOutlet weak var insideGifBottom: NSLayoutConstraint!
    //Buttons Constraintns
    @IBOutlet weak var openGifTrailing: NSLayoutConstraint!
    @IBOutlet weak var openSongLeading: NSLayoutConstraint!
    @IBOutlet weak var betweenButtons: NSLayoutConstraint!

    //Pop up variables
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popUpBackground: UIView!
    @IBOutlet weak var answerTextField: UITextField!
    //Pop up Constraintns
    @IBOutlet weak var popUpLeft: NSLayoutConstraint!
    @IBOutlet weak var popUpRight: NSLayoutConstraint!

    //Firebase
    var ref: FIRDatabaseReference!
    var userID: String?
    var theSetID = ""
    var tempSetID = ""

    //Helpers variables
    let musicEngine = MusicEngine()
    let randomSongEngine = RandomSong()
    let randomGifEngine = RandomGif()
    let spinner = Spinner()
    let colorLayer = ColorLayer()

    //Global variables
    var indicator: NVActivityIndicatorView?
    let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    //Double click
    let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
    var shouldChangeGif = false
    var gifURL = "Error"
    var songURL = "Error"
    var jsonSongURL = "Error"
    var fromFavoriteTable = false
    var fromHistoryTable = false
    var itemWasRemoved = false

    //Search settings
    var preSetGenre = "The Best"
    var preSetGifTag = "The Best"
    var preSetIteration = "Yes"

    //Variables for animation
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

    //Variables for changing gif opearation
    var isVcClosed = false
    var processIsWorking = false

    //Core data
    let coreDataFunctions = CoreDataFunctions()

    override func viewDidLoad() {
        super.viewDidLoad()

        //If from table(if you are from tablen then the set id isn't empty)
        if theSetID != "" {
            createUrlsWithSetID()
        }
        
        //Double click
        tap.numberOfTapsRequired = 2
        gifView.addGestureRecognizer(tap)

        //swipeControll
        gifView.addGestureRecognizer(gestureRecognizer)

        //Gesture recognizer to close the view after click on background
        let gesture = UITapGestureRecognizer(target: self, action: #selector (closePopUpWithTap))
        self.popUpBackground.addGestureRecognizer(gesture)
        
        //Don't use swipe back gesture
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        //Pop up view
        answerTextField.delegate = self
        popUpPreSet()

        //Firebase
        ref = FIRDatabase.database().reference()
        userID = FIRAuth.auth()?.currentUser?.uid

        //Initialization
        initialization()
        colorLayer.bothSideLightBlue(view: self.view)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startTheShow()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //Few actions to close the ViewController
        isVcClosed = true
        theGif.sd_cancelCurrentImageLoad()
        musicEngine.stopPlaying()
        musicEngine.deletePlayer()

        self.openGifButton.isHidden = true
        self.openSongButton.isHidden = true
        self.gifView.isHidden = true
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        if parent == nil {
            self.navigationController?.popPushAnimation(navigation: self.navigationController!)
        }
    }

    //Should show another gif?
    func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        //Counting moving
        let velocity = gestureRecognizer.velocity(in: self.theGif)
        let deltaX = velocity.x / 30

        //Gif way
        let newRightSpace = self.gifTrailing.constant - deltaX
        let newLeftSpace = self.gifLeading.constant + deltaX

        //Rotate gif
        let degreeCoef = self.gifViewWidth / 90
        var newDegree = newLeftSpace / degreeCoef
        if -newDegree > 45.0 {
            newDegree = lastDegree
        }
        if newDegree > 45.0 {
            newDegree = lastDegree
        }
        //Is swipe changed or ended
        if gestureRecognizer.state == .changed {
            setGifConstraints(left: newLeftSpace, right: newRightSpace, top: nil, bottom: nil)
            self.gifView.transform = CGAffineTransform(rotationAngle: (newDegree * CGFloat(Double.pi)) / 180.0)
            lastDegree = newDegree
            self.view.layoutIfNeeded()
        } else if gestureRecognizer.state == .ended {
            self.shouldChangeGif = abs(self.gifTrailing.constant) > (self.gifViewWidth / 2)
            //Change or no
            if shouldChangeGif {
                //Where user swiped and what to do
                var toGet = ""
                if self.gifTrailing.constant < 0 {
                    //Right
                    toGet = "Next"
                } else {
                    //Left
                    toGet = "Previous"
                }
                //If from some table to get value from there
                if fromHistoryTable {
                    getYourHistoryItem(whatToGet: toGet)
                } else if fromFavoriteTable {
                    getYourFavoriteItem(whatToGet: toGet)
                }

                startTheShow()
            } else {
                animateGifNotChanging()
            }
        }
    }

    //Funtion to open the url in Safari
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    @IBAction func openSong(_ sender: UIButton) {
        open(scheme: songURL)
    }

    @IBAction func openGif(_ sender: UIButton) {
        open(scheme: gifURL)
    }

    //Function that close pop up view if tapped on background
    func closePopUpWithTap(_ sender: UITapGestureRecognizer) {
        closePopUpView()
        self.likeTheSet.image = UIImage(named: "unliked")
    }

    //Close keyboard if return was tapped
    func textFieldShouldReturn(_ answerTextField: UITextField) -> Bool {
        answerTextField.resignFirstResponder()
        return true
    }

    //Pop up view cancel button
    @IBAction func cancelPopUpAction(_ sender: UIButton) {
        closePopUpView()
        self.likeTheSet.image = UIImage(named: "unliked")
    }

    //Pop up view accept button
    @IBAction func acceptPopUpAction(_ sender: UIButton?) {
        let answer = answerTextField.text!
        if answer != "" {
            //Add to the favorite list
            addToFavoriteList(name: answer)
            //Green animation
            allIsGoodAnimation()
        } else {
            //If smth bad - red animation
            smthWrongAnimation()
        }
    }

    //Function to like or dislike the set
    @IBAction func likeTheSetAction(_ sender: UIBarButtonItem) {
        likeTheSet.isEnabled = false
        if likeTheSet.image == UIImage(named: "unliked") {
            likeTheSet.image = UIImage(named: "liked")

            tempSetID = theSetID
            openPopViewIfNeeded()
        } else {
            likeTheSet.image = UIImage(named: "unliked")
            likeTheSet.isEnabled = true

            removeFromFavoriteList()
        }
    }
}
