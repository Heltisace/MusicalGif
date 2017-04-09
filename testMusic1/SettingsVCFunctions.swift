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
        createDropDown(view: genreDropButton, dropDown: genreDown, list: ["The Best", "Full random", "Custom"])
        genreDown.selectRow(at: 0)
        genreDown.selectionAction = { [unowned self] (index: Int, item: String) in
            let placeholder = "Enter your music genre here"
            self.openPopViewIfNeeded(item: item, index: index, button: self.genreDropButton, placeholder: placeholder)
        }
    }

    //Creating gif drop down list
    func createGifDown() {
        createDropDown(view: gifDropButton, dropDown: gifDown, list: ["The Best", "Full random", "Custom"])
        gifDown.selectRow(at: 0)
        gifDown.selectionAction = { [unowned self] (index: Int, item: String) in
            let placeholder = "Enter your gif tag here"
            self.openPopViewIfNeeded(item: item, index: index, button: self.gifDropButton, placeholder: placeholder)
        }
    }

    //Creating iteration choice drop down list
    func createIterationDown() {
        createDropDown(view: iterationDropButton, dropDown: iterationDown, list: ["Yes", "No"])
        iterationDown.selectRow(at: 0)
        iterationDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.musicIteration = item
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
    func closePopUpWitgTap(_ sender: UITapGestureRecognizer) {
        closePopUpView()
    }

    //Function to open pop up if it is needed or just select item of drop down list
    func openPopViewIfNeeded(item: String, index: Int, button: UIButton, placeholder: String) {
        if item == "Custom" {
            self.answerTextField.placeholder! = placeholder
            self.answerTextField.text! = ""

            self.view.layoutIfNeeded()
            //Pop up animation
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.popUpBackground.alpha = 0.5
                self.popUpView.alpha = 1
            })
        } else {
            button.setTitle(item, for: .normal)
            if answerTextField.placeholder == "Enter your gif tag here" {
                self.lastGifIndex = index
                self.gifTag = item
            } else {
                self.lastGenreIndex = index
                self.musicGenre = item
            }
        }
    }

    //Close pop up view
    func closePopUpView() {
        //Close pop up animation
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            //Remove pop up and background from view
            self.popUpBackground.alpha = 0
            self.popUpView.alpha = 0

            //Close keyboard
            self.answerTextField.resignFirstResponder()

            //If pop up cancelled to select last choice
            if self.answerTextField.placeholder == "Enter your gif tag here" {
                self.gifDown.selectRow(at: self.lastGifIndex)
            } else {
                self.genreDown.selectRow(at: self.lastGenreIndex)
            }
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
}
