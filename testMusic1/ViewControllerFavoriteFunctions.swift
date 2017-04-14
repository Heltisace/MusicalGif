//
//  FavoriteCreator.swift
//  testMusic1
//
//  Created by Heltisace on 29.03.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit

//Pop-up view
extension ViewController {
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
            self.answerTextField.placeholder = "Enter a name of the set here"
            self.answerTextField.text = ""

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
}
