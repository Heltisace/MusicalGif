//
//  LoginViewController.swift
//  testMusic1
//
//  Created by Heltisace on 28.03.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import SwiftSpinner

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let colorLayer = ColorLayer()
    
    //CoreData
    let coreDataFunctions = CoreDataFunctions()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDesign()
        
        //Results in CoreData
        let results = coreDataFunctions.getUser()
        if let result = results?.first {
            //Full screen spinner
            SwiftSpinner.useContainerView(self.view)
            SwiftSpinner.show("Connecting to server...")
            
            //Get user's data from Core Data
            let email = result.value(forKey: "email")! as! String
            let password = result.value(forKey: "password")! as! String
            
            //Trying to auth
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (_, error) in
                if error == nil {
                    //Go to menu and close spinner
                    let nc = self.storyboard?.instantiateViewController(withIdentifier: "MenuNC")
                    self.present(nc!, animated: true, completion: {
                        SwiftSpinner.hide()
                    })
                } else {
                    //Show error, delete user data and close spinner
                    SwiftSpinner.hide()
                    
                    let alertController = self.createAlert(title: "Error", message: (error?.localizedDescription)!, button: "OK", action: nil)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }

        //Delegating text fields
        emailTextField.delegate = self
        passwordTextField.delegate = self

        //Tap gesture to dismiss the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }

    @IBAction func loginAction(_ sender: UIButton?) {
        sender?.isEnabled = false

        //If both text fields aren't empty
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            //Show error
            let alertController = self.createAlert(title: "Error", message: "Please enter an email and password.", button: "OK", action: nil)
            self.present(alertController, animated: true, completion: {
                sender?.isEnabled = true
            })
        } else {
            //Setting uesr's data
            let email = self.emailTextField.text!
            let password = self.passwordTextField.text!

            //Trying to auth
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (_, error) in
                if error == nil {
                    //Delete user and add a new
                    self.coreDataFunctions.deleteUser()
                    self.coreDataFunctions.addUser(email: email, password: password)
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuNC")
                    self.present(vc!, animated: true, completion: nil)

                } else {
                    //Show error
                    let alertController = self.createAlert(title: "Error", message: (error?.localizedDescription)!, button: "OK", action: nil)
                    self.present(alertController, animated: true, completion: {
                        sender?.isEnabled = true
                    })
                }
            }
        }
    }

    @IBAction func goToSignUp(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUp")
        self.present(vc!, animated: true, completion: nil)
    }

    @IBAction func goToResetPassword(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPassword")
        self.present(vc!, animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            dismissKeyboard()
            loginAction(nil)
        }
        return false
    }

    func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

extension LoginVC {
    func loadDesign() {
        colorLayer.bottomLightBlue(view: self.view)
        loginButton.backgroundColor = UIColor(white: 1, alpha: 0.4)
        emailTextField.backgroundColor = UIColor(white: 1, alpha: 0.8)
        passwordTextField.backgroundColor = UIColor(white: 1, alpha: 0.8)
    }
}
