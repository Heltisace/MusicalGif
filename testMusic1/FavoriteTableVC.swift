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

class FavoriteTableVC: UITableViewController {

    var names: [String] = []
    var theSetIDs: [String] = []
    var presentingSetIndex = 0

    var ref: FIRDatabaseReference!
    var userID: String?

    var cellIsEditing = false
    var goingToTheMain = false

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

            let combined = zip(self.names,
                               self.theSetIDs).sorted{$0.0 < $1.0}
            self.names = combined.map {$0.0}
            self.theSetIDs = combined.map {$0.1}

            self.tableView.reloadData()
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !goingToTheMain {
            ref.child("Users").child(userID!).removeAllObservers()
        }
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        if parent == nil {
            self.navigationController?.popPushAnimation(navigation: self.navigationController!)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        goingToTheMain = false
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
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { _, index in
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

        let lightBlue = UIColor(colorLiteralRed: 52 / 255, green: 152 / 255, blue: 230 / 255, alpha: 1)
        edit.backgroundColor = lightBlue

        let delete = UITableViewRowAction(style: .normal, title:
        "Delete") { _, index in
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
            goingToTheMain = true
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as!ViewController
            vc.theSetID = self.theSetIDs[indexPath.row]
            self.presentingSetIndex = indexPath.row
            vc.fromFavoriteTable = true
            vc.title = self.names[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: false)
            self.navigationController?.popPushAnimation(navigation: self.navigationController!)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.endEditing(true)
            cellIsEditing = false
        }
    }
}
