//
//  MenuVC.swift
//  testMusic1
//
//  Created by Heltisace on 14.03.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreData

class MenuVC: UIViewController {
    
    let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "User")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}
