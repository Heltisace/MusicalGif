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
    @IBOutlet weak var randomSetButton: RoundButton!
    @IBOutlet weak var favoriteButton: RoundButton!
    @IBOutlet weak var logOutButton: RoundButton!
    
    let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "User")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Background
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "black_texture")!)
        
        //Configure button
        logOutButton.makeTheButtonRed()
        randomSetButton.makeTheButtonGreen()
        
        //If user's connetion is bad
        badConnection()
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
    
    @IBAction func logOutAction(_ sender: RoundButton?) {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                
                deleteUser()
                
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
    
    @IBAction func goToFavoriteTable(_ sender: RoundButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavoriteVC")
        self.show(vc!, sender: self)
    }
    @IBAction func goToHistoryTable(_ sender: RoundButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HistoryVC")
        self.show(vc!, sender: self)
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
