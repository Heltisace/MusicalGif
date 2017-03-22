//
//  SettingsVC.swift
//  testMusic1
//
//  Created by Heltisace on 14.03.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit
import DropDown

class SettingsVC: UIViewController, UITextFieldDelegate{
    //Drop down lists
    @IBOutlet weak var genreDropButton: UIButton!
    @IBOutlet weak var gifDropButton: UIButton!
    @IBOutlet weak var iterationDropButton: UIButton!
    
    //Constratints of pop up view
    @IBOutlet weak var popUpBottom: NSLayoutConstraint!
    @IBOutlet weak var popUpRight: NSLayoutConstraint!
    @IBOutlet weak var popUpTop: NSLayoutConstraint!
    @IBOutlet weak var popUpLeft: NSLayoutConstraint!
    
    //Views
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popUpBackground: UIView!
    
    //Text field
    @IBOutlet weak var answerTextField: UITextField!
    
    //Drop downs and their helpers
    let genreDown = DropDown()
    let gifDown = DropDown()
    let iterationDown = DropDown()
    var lastGifIndex = 0
    var lastGenreIndex = 0
    
    //Variables used to send info to ViewController
    let gifEngine = RandomGif()
    let randomSong = RandomSong()
    var gifTag = "The Best"
    var musicGenre = "The Best"
    var musicIteration = "Yes"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Gesture recognizer to close the view after click on background
        let gesture = UITapGestureRecognizer(target: self, action: #selector (closePopUpWitgTap))
        self.popUpBackground.addGestureRecognizer(gesture)
        
        //Creating drop down lists
        createGifDown()
        createGenreDown()
        createIterationDown()
        
        //Delegate
        answerTextField.delegate = self
    }
    @IBAction func goToMainVC(_ sender: UIButton) {
        //Animation of push ViewController
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            
            //VC
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MainVC") as! ViewController
            
            //Send information to ViewController
            vc.preSetIteration = self.musicIteration
            vc.preSetGenre = self.musicGenre
            vc.preSetGifTag = self.gifTag
            
            self.navigationController?.pushViewController(vc, animated: false)
            //Animation
            UIView.setAnimationTransition(UIViewAnimationTransition.curlDown, for: self.navigationController!.view!, cache: false)
        })
    }
    
    @IBAction func showGenreDropDown(_ sender: UIButton) {
        genreDown.show()
    }
    
    @IBAction func showGifDropDown(_ sender: UIButton) {
        gifDown.show()
    }
    
    @IBAction func showIterationDropDown(_ sender: UIButton) {
        iterationDown.show()
    }
    
    func textFieldShouldReturn(_ tagTextField: UITextField) -> Bool {
        tagTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func getAnswer(_ sender: UIButton) {
        //Is field empty?
        if answerTextField.text! != "" {
            //Replace or delete all spaces
            var tempAnswer = answerTextField.text!
            if tempAnswer.characters.last == " " {
                tempAnswer.remove(at: tempAnswer.index(before: tempAnswer.endIndex))
            }
            tempAnswer = tempAnswer.replacingOccurrences(of: " ", with: "%20")
            print(tempAnswer)
            
            //Working with gif or music?
            if answerTextField.placeholder! == "Enter your gif tag here" {
                //If genre is exist
                if gifEngine.getGifWithTag(tag: tempAnswer) != "Error" {
                    //Initialization
                    gifTag = tempAnswer
                    gifDropButton.setTitle(answerTextField.text!, for: .normal)
                    lastGifIndex = 2
                    
                    //Close pop up view with succes
                    allIsGoodAnimation()
                } else {
                    smthWrongAnimation()
                }
            } else {
                //Intialization
                let jsonUrl = randomSong.getJsonUrlWithGenre(genre: tempAnswer)
                let songJson = randomSong.getSongJson(jsonUrl: jsonUrl)
                //If there is any gif with tag
                if randomSong.getTotalNumberOfSongs(data: songJson) != "0" {
                    //Initialization
                    musicGenre = tempAnswer
                    genreDropButton.setTitle(answerTextField.text!, for: .normal)
                    lastGenreIndex = 2
                    
                    //Close pop up view with succes
                    allIsGoodAnimation()
                } else {
                    smthWrongAnimation()
                }
            }
        } else {
            smthWrongAnimation()
        }
    }
    
    @IBAction func cancelGifTag(_ sender: UIButton) {
        closePopUpView()
    }
}
