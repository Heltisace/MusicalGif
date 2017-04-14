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
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var bottomView: UIView!

    let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "User")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let colorLayer = ColorLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDesign()

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
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
                let alertController = self.createAlert(title: "Error", message: error.localizedDescription, button: "OK", action: nil)
                present(alertController, animated: true, completion: nil)
            }
        }
    }

    @IBAction func goToSetSettings(_ sender: RoundButton) {
        if !logOutButton.isSelected {
            self.navigationController?.popPushAnimation(navigation: self.navigationController!)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC")
            self.navigationController?.pushViewController(vc!, animated: false)
        }
    }

    @IBAction func goToFavoriteTable(_ sender: RoundButton) {
        if !logOutButton.isSelected {
            self.navigationController?.popPushAnimation(navigation: self.navigationController!)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavoriteVC")
            self.navigationController?.pushViewController(vc!, animated: false)
        }
    }
    @IBAction func goToHistoryTable(_ sender: RoundButton) {
        if !logOutButton.isSelected {
            self.navigationController?.popPushAnimation(navigation: self.navigationController!)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HistoryVC")
            self.navigationController?.pushViewController(vc!, animated: false)
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
}

//Check internet connection extension
extension MenuVC {
    func badConnection() {
        //If bad connection is using
        if CheckConnection().connectionStatus().description.contains("WWAN") {
            let error = "Your internet connection is slow. We recommend you to use a faster one."
            let alertController = self.createAlert(title: "Warning", message: error, button: "OK", action: nil)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
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
            let alertController = self.createAlert(title: "Error", message: error, button: "Try again", action: {
                //Try to get new gif vc is ViewController
                if self.navigationController?.topViewController is ViewController {
                    let vc = self.navigationController?.topViewController as! ViewController
                    vc.startTheShow()
                }
                self.networkStatusChanged(notification)
            })
            self.present(alertController, animated: true, completion: nil)
        default: break
        }
    }
}

//Design
extension MenuVC {
    func loadDesign() {
        colorLayer.topLightBlue(view: self.view)
        colorLayer.bothSideLightBlue(view: logoView)
        colorLayer.bottomLightBlue(view: bottomView)
        
        makeShadow(view: logoView)
        makeShadow(view: bottomView)
        
        setBackgroundAlpha(view: randomSetButton, alpha: 0.2)
        setBackgroundAlpha(view: favoriteButton, alpha: 0.2)
        setBackgroundAlpha(view: logOutButton, alpha: 0.2)
        setBackgroundAlpha(view: historyButton, alpha: 0.2)
    }
}
