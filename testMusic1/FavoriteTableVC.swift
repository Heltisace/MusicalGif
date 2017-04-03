//
//  FavoriteTableVC.swift
//  testMusic1
//
//  Created by Heltisace on 30.03.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit
import Firebase
import SwiftSpinner
import os.log

class FavoriteTableVC: UITableViewController {
    
    var names: [String] = []
    var theSetIDs: [String] = []
    
    var ref: FIRDatabaseReference!
    var userID: String?
    
    var cellIsEditing = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        userID = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("Users").child(userID!).observe(FIRDataEventType.value, with: { (snapshot) in
            self.theSetIDs.removeAll()
            self.names.removeAll()
            self.tableView.reloadData()
            
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            for dict in postDict {
                self.theSetIDs.append(dict.key)
                self.names.append(dict.value as! String)
            }
            
            let combined = zip(self.names, self.theSetIDs).sorted {$0.0 < $1.0}
            self.names = combined.map {$0.0}
            self.theSetIDs = combined.map {$0.1}
            
            self.tableView.reloadData()
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell", for: indexPath) as! FavoriteTableViewCell
        
        cell.nameOfTheSet.text = names[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            self.cellIsEditing = true
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell", for: index) as! FavoriteTableViewCell
            cell.editTextField.alpha = 1
            cell.editTextField.becomeFirstResponder()
            cell.editTextField.text = self.names[index.row]
            cell.nameOfTheSet.alpha = 0
            
            //Closure to set new favorite name
            cell.changeFavoriteName = {
                self.cellIsEditing = false
                if cell.editTextField.text! != "" {
                    let theSetID = self.theSetIDs[index.row]
                    let newName = cell.editTextField.text!
                    self.ref.child("Users").child(self.userID!).child(theSetID).setValue(newName)
                }
            }
            
            tableView.reloadRows(at: [index], with: .none)
        }
        edit.backgroundColor = UIColor.blue
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let theSetID = self.theSetIDs.remove(at: index.row)
            self.names.remove(at: index.row)
            self.ref.child("Users").child(self.userID!).child(theSetID).removeValue()
            tableView.reloadData()
        }
        delete.backgroundColor = .red
        
        return [delete, edit]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !cellIsEditing {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! ViewController
            vc.theSetID = self.theSetIDs[indexPath.row]
            vc.ifFromFavoriteTable = true
            
            self.show(vc, sender: self)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.endEditing(true)
            cellIsEditing = false
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }*/

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
 
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.tableView.reloadData()
    }
    
    */
}
