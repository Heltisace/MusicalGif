//
//  MenuVC.swift
//  testMusic1
//
//  Created by Heltisace on 14.03.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import SwiftSpinner

class MenuVC: UIViewController {
    @IBOutlet weak var randomSetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var historyButton: SimpleRoundButton!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!

    let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "User")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let colorLayer = ColorLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        //Background
        colorLayer.createLayer(someView: self.view)
        topView.backgroundColor? = UIColor(white: 1, alpha: 0.85)
        logoView.backgroundColor? = UIColor(white: 1, alpha: 0.85)
        bottomView.backgroundColor? = UIColor(white: 1, alpha: 0.85)
        
        logoView.layer.shadowColor = UIColor.black.cgColor
        logoView.layer.shadowOpacity = 1
        logoView.layer.shadowOffset = CGSize.zero
        logoView.layer.shadowRadius = 10
        
        bottomView.layer.shadowColor = UIColor.black.cgColor
        bottomView.layer.shadowOpacity = 1
        bottomView.layer.shadowOffset = CGSize.zero
        bottomView.layer.shadowRadius = 10
        randomSetButton.backgroundColor = randomSetButton.backgroundColor?.withAlphaComponent(0.2)
        favoriteButton.backgroundColor = favoriteButton.backgroundColor?.withAlphaComponent(0.2)
        logOutButton.backgroundColor = logOutButton.backgroundColor?.withAlphaComponent(0.2)
        historyButton.backgroundColor = historyButton.backgroundColor?.withAlphaComponent(0.2)

        
        //Configure button
        //logOutButton.makeTheButtonRed()
        //randomSetButton.makeTheButtonGreen()

        //If user's connetion is bad
        badConnection()

        //If no connection
        loopCheck()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("Users").child(userID!).removeAllObservers()
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    @IBAction func logOutAction(_ sender: RoundButton?) {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                deleteUser()
                NotificationCenter.default.removeObserver(self)

                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                self.present(vc!, animated: true, completion: nil)
            } catch let error as NSError {
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)

                present(alertController, animated: true, completion: nil)
            }
        }
    }

    @IBAction func goToSetSettings(_ sender: RoundButton) {
        if !logOutButton.isSelected {
            UIView.animate(withDuration: 0.75, animations: { () -> Void in
                UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC")
                self.show(vc!, sender: self)
                //Animation
                UIView.setAnimationTransition(UIViewAnimationTransition.flipFromLeft, for: self.navigationController!.view!, cache: false)
            })
        }
    }

    @IBAction func goToFavoriteTable(_ sender: RoundButton) {
        if !logOutButton.isSelected {
            UIView.animate(withDuration: 0.75, animations: { () -> Void in
                UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavoriteVC")
                self.show(vc!, sender: self)
                //Animation
                UIView.setAnimationTransition(UIViewAnimationTransition.flipFromLeft, for: self.navigationController!.view!, cache: false)
            })
        }
    }
    @IBAction func goToHistoryTable(_ sender: RoundButton) {
        if !logOutButton.isSelected {
            UIView.animate(withDuration: 0.75, animations: { () -> Void in
                UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HistoryVC")
                self.show(vc!, sender: self)
                //Animation
                UIView.setAnimationTransition(UIViewAnimationTransition.flipFromLeft, for: self.navigationController!.view!, cache: false)
            })
        }
    }

    func deleteUser() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        do {
            let results = try context.fetch(fetchRequest)
            for result in results {
                context.delete(result)
            }
            appDelegate.saveContext()
        } catch {
            print("error")
        }
    }

    func badConnection() {
        //If bad connection is using
        if CheckConnection().connectionStatus().description.contains("WWAN") {
            let error = "Your internet connection is slow. We recommend you to use a faster one."
            let alertController = UIAlertController(title: "Warning", message: error, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)

            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension MenuVC {
    func loopCheck() {
        NotificationCenter.default.addObserver(self, selector:
            #selector(self.networkStatusChanged(_:)), name:
            NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        CheckConnection().monitorReachabilityChanges()
    }

    func networkStatusChanged(_ notification: Notification) {
        let status = CheckConnection().connectionStatus()
        switch status {
        case .unknown, .offline:
            //Show error
            let error = "Network error (such as timeout, interrupted" +
            "connection or unreachable host) has occurred."
            let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Try again", style:
                .cancel, handler: { (_: UIAlertAction!) in
                    //Try to get new gif vc is ViewController
                    if self.navigationController?.topViewController is ViewController {
                        let vc = self.navigationController?.topViewController as! ViewController
                        vc.startTheShow()
                    }
                    self.networkStatusChanged(notification)
            })
            alertController.addAction(defaultAction)

            self.present(alertController, animated: true, completion: nil)
        default: break
        }
    }
}
