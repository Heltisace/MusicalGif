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
    
    var isWorking = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @IBAction func signUpAction(_ sender: UIButton?) {
        if isWorking == false {
            isWorking = true
            
            if emailTextField.text == "" || passwordTextField.text == "" {
                //Show error
                let alertController = UIAlertController(title:
                    "Error", message: "Please enter your email and password", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                present(alertController, animated: true, completion: {
                    self.isWorking = false
                })
                
            } else if passwordTextField.text != confirmPasswordTextField.text {
                //Show error
                let alertController = UIAlertController(title:
                    "Error", message: "The entered passwords do not match.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                present(alertController, animated: true, completion: {
                    self.isWorking = false
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
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: {
                            self.isWorking = false
                        })
                    }
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
            signUpAction(nil)
        }
        return false
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
