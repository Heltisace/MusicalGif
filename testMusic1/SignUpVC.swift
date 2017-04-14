//
//  SignUpViewController.swift
//  testMusic1
//
//  Created by Heltisace on 28.03.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit
import Firebase

class SignUpVc: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    let colorLayer = ColorLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.backgroundColor = UIColor(white: 1, alpha: 0.4)
        colorLayer.orangeLayer(view: self.view)

        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }

    @IBAction func signUpAction(_ sender: UIButton?) {
        sender?.isEnabled = false
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            //Show error
            let alertController = self.createAlert(title: "Error", message: "Please enter your email and password", button: "OK", action: nil)
            present(alertController, animated: true, completion: {
                sender?.isEnabled = true
            })
        } else if passwordTextField.text != confirmPasswordTextField.text {
            //Show error
            let alertController = self.createAlert(title: "Error", message: "The entered passwords do not match.", button: "OK", action: nil)
            present(alertController, animated: true, completion: {
                sender?.isEnabled = true
            })
        } else {
            //Trying to create user
            FIRAuth.auth()?.createUser(withEmail:emailTextField.text!, password:
            passwordTextField.text!) { (_, error) in
                
                if error == nil {
                    //Sign out of user and go to login
                    do {
                        try FIRAuth.auth()?.signOut()
                    } catch {
                        print("There can't be any errors")
                    }
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                    self.present(vc!, animated: true, completion: nil)
                } else {
                    //Can't create user - show error
                    let alertController = self.createAlert(title: "Error", message: (error?.localizedDescription)!, button: "OK", action: nil)
                    self.present(alertController, animated: true, completion: {
                        sender?.isEnabled = true
                    })
                }
            }
        }
    }

    @IBAction func goToLogin(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(vc!, animated: true, completion: nil)
    }

    @IBAction func goToResetPassword(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPassword")
        self.present(vc!, animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else {
            dismissKeyboard()
            signUpAction(nil)
        }
        return false
    }

    func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
