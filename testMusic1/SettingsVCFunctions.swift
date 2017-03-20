//
//  SettingsVCFunctions.swift
//  testMusic1
//
//  Created by Heltisace on 14.03.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit
import DropDown

extension SettingsVC {
    //Creating genre drop down list
    func createGenreDown() {
        createDropDown(view: genreDropButton, dropDown: genreDown, list: ["Demonstation","Rock","Pop"])
        genreDown.selectRow(at: 0)
        genreDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.genreDropButton.setTitle(item, for: .normal )
        }
    }
    //Creating gif drop down list
    func createGifDown() {
        createDropDown(view: gifDropButton, dropDown: gifDown, list: ["Demonstration","Full random", "Custom"])
        gifDown.selectRow(at: 0)
        gifDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if item == "Custom" {
                //Prepear for pop up
                self.popUpTop.constant = self.view.frame.height / 3.6
                self.popUpRight.constant = self.view.frame.width / 100
                self.popUpBottom.constant = self.view.frame.height / 2.6
                self.popUpLeft = self.popUpRight
        
                self.view.layoutIfNeeded()
                //Pop up animation
                UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    self.popUpBackground.alpha = 0.5
                    self.popUpView.alpha = 1
                })
            } else {
                self.gifDropButton.setTitle(item, for: .normal )
                self.lastGifIndex = index
            }
        }
    }
    //Creating iteration choice drop down list
    func createIterationDown() {
        createDropDown(view: iterationDropButton, dropDown: iterationDown, list: ["Yes", "No"])
        iterationDown.selectRow(at: 0)
        iterationDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.iterationDropButton.setTitle(item, for: .normal )
        }
    }
    //Function for creating drop downs
    func createDropDown(view: UIView, dropDown: DropDown, list: [String]) {
        dropDown.anchorView = view
        dropDown.dataSource = list
        dropDown.direction = .bottom
    }
    //Function that close pop up view if tapped on background
    func closePopUpWitgTap(_ sender:UITapGestureRecognizer) {
        closePopUpView()
    }
    func closePopUpView() {
        //Close pop up animation
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            //Remove pop up and background from view
            self.popUpBackground.alpha = 0
            self.popUpView.alpha = 0
            //Close keyboard
            self.tagTextField.resignFirstResponder()
            //If pop up cancelled to select last choice
            self.gifDown.selectRow(at: self.lastGifIndex)
        })
    }
    //Red background
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
}
