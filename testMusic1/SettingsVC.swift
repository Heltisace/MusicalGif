//
//  SettingsVC.swift
//  testMusic1
//
//  Created by Heltisace on 14.03.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBAction func goToMainVC(_ sender: UIButton) {
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MainVC") as! ViewController
            self.navigationController?.pushViewController(vc, animated: false)
            //self.navigationController?.present(vc, animated: false, completion: nil)
            
            UIView.setAnimationTransition(UIViewAnimationTransition.flipFromRight, for: self.navigationController!.view!, cache: false)
        })
    }
}
