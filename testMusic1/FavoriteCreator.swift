//
//  FavoriteCreator.swift
//  testMusic1
//
//  Created by Heltisace on 29.03.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit
import Firebase

extension ViewController {
    
    ///////////////////////////////////////////////
    //Pop up functions//
    ///////////////////////////////////////////////
    
    //Close pop up view
    func closePopUpView() {
        //Close pop up animation
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            //Remove pop up and background from view
            self.popUpBackground.alpha = 0
            self.popUpView.alpha = 0
            
            //Close keyboard
            self.answerTextField.resignFirstResponder()
        }, completion: { _ in
            self.likeTheSet.isEnabled = true
        })
    }
    
    func popUpPreSet() {
        self.popUpTop.constant = self.view.frame.height / 3.6
        self.popUpRight.constant = self.view.frame.width / 100
        self.popUpBottom.constant = self.view.frame.height / 2.6
        self.popUpLeft.constant = self.view.frame.width / 100
    }
    
    //Function that opens pop up if it is needed or just select item of drop down list
    func openPopViewIfNeeded() {
            //Prepear for pop up
            self.answerTextField.placeholder! = "Enter a name of the set here"
            self.answerTextField.text! = ""
            
            self.view.layoutIfNeeded()
            //Pop up animation
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.popUpBackground.alpha = 0.5
                self.popUpView.alpha = 1
            })
    }
    
    //All is good animation
    func allIsGoodAnimation() {
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
    }
    
    //Smth wrong animation
    func smthWrongAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.popUpBackground.backgroundColor = .red
            self.popUpBackground.alpha = 0.9
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.popUpBackground.backgroundColor = .black
            self.popUpBackground.alpha = 0.5
        })
    }
    
    ///////////////////////////////////////////////
    //Firebase functions//
    ///////////////////////////////////////////////
    
    //Check the set for existing in favorites
    func checkForExisting() {
        generateSetID()
        
        ref.child("Users").child(userID!).child(theSetID).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if value != nil {
                self.likeTheSet.image = UIImage(named: "thumb-up")
                self.likeTheSet.isEnabled = true
            } else {
                self.likeTheSet.image = UIImage(named: "thumb-down")
                self.likeTheSet.isEnabled = true
            }
        })
    }
    
    //Add the set to favorite
    func addToFavoriteList(name: String) {
        ref.child("Users").child(userID!).child(theSetID).setValue(name)
    }
    
    //Remove the set from favorite
    func removeFromFavoriteList() {
        ref.child("Users").child(userID!).child(theSetID).removeValue()
    }
    
    //To generate the set ID with it's unique parts of urls
    func generateSetID(){
        //Getting the number of gif media
        var mediaNumber = ""
        
        for index in gifURL.characters.indices {
            if mediaNumber == "" {
                if let number = Int(String(gifURL[index])) {
                    mediaNumber = String(number)
                }
            }
        }
        
        //Getting the gif ID
        var arrayOfGifUrlSlashes: [String.Index] = []
        
        for index in gifURL.characters.indices {
            if gifURL[index] == "/" {
                arrayOfGifUrlSlashes.append(index)
            }
        }
        var firstIndex = gifURL.index(arrayOfGifUrlSlashes[3], offsetBy: 1)
        var secondIndex = gifURL.index(arrayOfGifUrlSlashes[4], offsetBy: -1)
        let gifID = gifURL[firstIndex...secondIndex]
        
        //Getting song ID
        firstIndex = songURL.startIndex
        secondIndex = songURL.index(before: songURL.endIndex)
        
        for index in songURL.characters.indices {
            if songURL[index] == "/" {
                firstIndex = songURL.index(index, offsetBy: 1)
            }
        }
        let songPreviewID = songURL[firstIndex...secondIndex]
        
        //Generating the set ID
        theSetID = mediaNumber + "|" + gifID + "|" + songPreviewID
    }
    
    func createUrlsWithSetID(){
        //TO DO
    }
}
