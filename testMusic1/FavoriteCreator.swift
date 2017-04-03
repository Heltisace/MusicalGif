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
        self.popUpRight.constant = self.view.frame.width / 100
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
        if !ifFromFavoriteTable {
            generateSetID()
        }
        
        ref.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            if postDict.keys.contains(self.theSetID) {
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
        ref.child("Users").child(userID!).child(tempSetID).setValue(name)
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
        firstIndex = jsonSongURL.startIndex
        secondIndex = jsonSongURL.index(before: jsonSongURL.endIndex)
        
        for index in jsonSongURL.characters.indices {
            if jsonSongURL[index] == "/" {
                firstIndex = jsonSongURL.index(index, offsetBy: 1)
            }
        }
        let songJsonID = jsonSongURL[firstIndex...secondIndex]
        
        //Generating the set ID
        theSetID = mediaNumber + "|" + gifID + "|" + songJsonID
    }
    
    func createUrlsWithSetID(){
        var arrayOfGifUrlSlashes: [String.Index] = []
        
        for index in theSetID.characters.indices {
            if theSetID[index] == "|" {
                arrayOfGifUrlSlashes.append(index)
            }
        }
        var firstIndex = theSetID.index(arrayOfGifUrlSlashes[0], offsetBy: 1)
        var secondIndex = theSetID.index(arrayOfGifUrlSlashes[1], offsetBy: -1)
        
        let gifMedia = Int(String(theSetID[theSetID.startIndex]))!
        let gifID = theSetID[firstIndex...secondIndex]
        gifURL = "http://media\(gifMedia).giphy.com/media/\(gifID)/giphy.gif"
        
        firstIndex = theSetID.index(arrayOfGifUrlSlashes[1], offsetBy: 1)
        secondIndex = theSetID.index(theSetID.endIndex, offsetBy: -1)
        
        let songID = theSetID[firstIndex...secondIndex]
        jsonSongURL = "https://api.spotify.com/v1/\(songID)"
    }
}
