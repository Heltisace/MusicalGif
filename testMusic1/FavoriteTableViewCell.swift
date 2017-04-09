//
//  FavoriteTableViewCell.swift
//  testMusic1
//
//  Created by Heltisace on 30.03.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit
import Firebase

class FavoriteTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var nameOfTheSet: UILabel!
    @IBOutlet weak var editTextField: UITextField!

    var ref: FIRDatabaseReference!
    var userID: String?

    var changeFavoriteName: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        ref = FIRDatabase.database().reference()
        userID = FIRAuth.auth()?.currentUser?.uid

        editTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        editTextField.resignFirstResponder()
        editTextField.alpha = 0
        nameOfTheSet.alpha = 1

        self.changeFavoriteName?()

        return false
    }

}
