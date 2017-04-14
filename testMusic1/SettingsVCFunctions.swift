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
        
        genreDown.cellNib = UINib(nibName: "MyCell", bundle: nil)
        genreDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? MyCell else { return }
            // Setup your custom UI components
            cell.suffixLabel.text = item
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
        
        gifDown.cellNib = UINib(nibName: "MyCell", bundle: nil)
        gifDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? MyCell else { return }
            // Setup your custom UI components
            cell.suffixLabel.text = item
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
        
        iterationDown.cellNib = UINib(nibName: "MyCell", bundle: nil)
        iterationDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? MyCell else { return }
            // Setup your custom UI components
            cell.suffixLabel.text = item
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

extension SettingsVC {
    func loadDesign() {
        //Background
        colorLayer.topLightBlue(view: self.view)
        colorLayer.bottomLightBlue(view: iterationBottom)
        colorLayer.topLightBlue(view: gifTitleView)
        colorLayer.bothSideLightBlue(view: musicTitleView)
        colorLayer.bothSideLightBlue(view: iterationTitleView)
        colorLayer.bottomLightBlue(view: bottomView)
        
        makeShadow(view: iterationBottom)
        makeShadow(view: iterationTitleView)
        makeShadow(view: musicTitleView)
        makeShadow(view: gifTitleView)
        makeShadow(view: bottomView)
        
        setBackgroundAlpha(view: continueButton, alpha: 0.2)
        setBackgroundAlpha(view: gifDropButton, alpha: 0.7)
        setBackgroundAlpha(view: genreDropButton, alpha: 0.7)
        setBackgroundAlpha(view: iterationDropButton, alpha: 0.7)
    }
}
