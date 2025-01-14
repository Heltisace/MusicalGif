//
//  HistoryTableVC.swift
//  testMusic1
//
//  Created by Heltisace on 06.04.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit
import CoreData

class HistoryTableVC: UITableViewController {

    var theSetIDs: [String] = []
    var presentingSetIndex = 0

    let coreDataFunctions = CoreDataFunctions()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let results = coreDataFunctions.getHistory()
        if results != nil {
            for result in results! {
                let info = result.value(forKey: "setID")
                theSetIDs.insert(info as! String, at: 0)
            }
            self.tableView.reloadData()
        }
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        if parent == nil {
            self.navigationController?.popPushAnimation(navigation: self.navigationController!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return theSetIDs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell

        cell.historyLabel.text = String(indexPath.row + 1)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //VC
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! ViewController
        vc.theSetID = self.theSetIDs[indexPath.row]
        self.presentingSetIndex = indexPath.row
        vc.fromHistoryTable = true
        vc.title = "History №" + String(self.presentingSetIndex+1)
        
        self.navigationController?.pushViewController(vc, animated: false)
        //Animation
        self.navigationController?.popPushAnimation(navigation: self.navigationController!)
    }
}
