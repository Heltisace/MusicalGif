//
//  ResetPassViewController.swift
//  testMusic1
//
//  Created by Heltisace on 28.03.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    var isWorking = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @IBAction func resetPasswordAction(_ sender: UIButton?) {
        if isWorking == false{
            isWorking = true
            
            if self.emailTextField.text == "" {
                //Show error
                let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                present(alertController, animated: true, completion: {
                    self.isWorking = false
                })
            } else {
                //Trying to reset user's password
                FIRAuth.auth()?.sendPasswordReset(withEmail: self.emailTextField.text!, completion: { (error) in
                    var title = ""
                    var message = ""
                    
                    if error != nil {
                        //Variables with error
                        title = "Error!"
                        message = (error?.localizedDescription)!
                    } else {
                        //Variables with success
                        title = "Success!"
                        message = "Password reset email sent."
                        self.emailTextField.text = ""
                        self.view.endEditing(true)
                    }
                    
                    //Show message with varibales
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: {
                        self.isWorking = false
                    })
                })
            }
        }
    }
    
    @IBAction func goToLogin(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func goToSignUp(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUp")
        self.present(vc!, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        resetPasswordAction(nil)
        
        return false
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
