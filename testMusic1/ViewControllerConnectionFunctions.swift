//
//  ViewControllerConnectionFunctions.swift
//  testMusic1
//
//  Created by Heltisace on 05.04.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit

extension ViewController {
    func loopCheck() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        CheckConnection().monitorReachabilityChanges()
    }
    
    func networkStatusChanged(_ notification: Notification) {
        let status = CheckConnection().connectionStatus()
        switch status {
        case .unknown, .offline:
            //Show error
            let error = "Network error (such as timeout, interrupted connection or unreachable host) has occurred." 
            let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Try again", style: .cancel, handler: {
                (alert: UIAlertAction!) in
                self.startTheShow()
                self.networkStatusChanged(notification)
            })
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        default: break
        }
    }
}
