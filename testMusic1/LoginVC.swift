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

    //For CoreData
    let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "User")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            //Results in CoreData
            let results = try context.fetch(fetchRequest)
            if let result = results.first {
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

                        let alertController = UIAlertController(title:
                            "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)

                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        } catch {
            print("error")
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
            let alertController = UIAlertController(title:
                "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)

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
                    //Delete users
                    let menuVc = self.storyboard?.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
                    menuVc.deleteUser()

                    guard let appDelegate =
                        UIApplication.shared.delegate as? AppDelegate else {
                            return
                    }

                    //Creating new variable in CoreData
                    let entity = NSEntityDescription.entity(forEntityName: "User", in: self.context)!
                    let dataTask = NSManagedObject(entity: entity, insertInto: self.context)

                    //Setting data to variable
                    dataTask.setValue(email, forKey: "email")
                    dataTask.setValue(password, forKey: "password")

                    //Save data with appDelegate function
                    appDelegate.saveContext()

                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuNC")
                    self.present(vc!, animated: true, completion: nil)

                } else {
                    //Show error
                    let alertController = UIAlertController(title:
                        "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)

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
            self.view.endEditing(true)
            loginAction(nil)
        }
        return false
    }

    func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
