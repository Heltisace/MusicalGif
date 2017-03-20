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
    
    @IBOutlet weak var genreDropButton: UIButton!
    @IBOutlet weak var gifDropButton: UIButton!
    @IBOutlet weak var iterationDropButton: UIButton!
    
    @IBOutlet weak var popUpBottom: NSLayoutConstraint!
    @IBOutlet weak var popUpRight: NSLayoutConstraint!
    @IBOutlet weak var popUpTop: NSLayoutConstraint!
    @IBOutlet weak var popUpLeft: NSLayoutConstraint!
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popUpBackground: UIView!
    
    @IBOutlet weak var tagTextField: UITextField!
    
    let genreDown = DropDown()
    let gifDown = DropDown()
    let iterationDown = DropDown()
    var lastGifIndex = 0
    
    let gifEngine = RandomGif()
    var gifTag = "Demonstration"
    var musicGenre = "Demonstration"
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
        tagTextField.delegate = self
    }
    @IBAction func goToMainVC(_ sender: UIButton) {
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MainVC") as! ViewController
            self.navigationController?.pushViewController(vc, animated: false)
            //self.navigationController?.present(vc, animated: false, completion: nil)
            
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
    @IBAction func getGifTag(_ sender: UIButton) {
        if tagTextField.text! != "" {
            var tempTag = tagTextField.text!
            if tempTag.characters.last == " " {
                tempTag.remove(at: tempTag.index(before: tempTag.endIndex))
            }
            tempTag = tempTag.replacingOccurrences(of: " ", with: "%20")
            print(tempTag)
            if gifEngine.getGifWithTag(tag: tempTag) != "Error" {
                //Initialization
                gifTag = tagTextField.text!
                gifDropButton.setTitle(gifTag, for: .normal)
                lastGifIndex = 2
                //All is goof animation
                UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    self.popUpBackground.backgroundColor = .green
                    self.popUpBackground.alpha = 0.9
                })
                UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    self.popUpBackground.backgroundColor = .black
                    self.popUpBackground.alpha = 0.5
                }, completion: { _ in
                    self.closePopUpView()
                })
            } else {
                smthWrongAnimation()
            }
        } else {
            smthWrongAnimation()
        }
    }
    @IBAction func cancelGifTag(_ sender: UIButton) {
        closePopUpView()
    }
}
