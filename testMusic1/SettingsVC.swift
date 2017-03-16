//
//  SettingsVC.swift
//  testMusic1
//
//  Created by Heltisace on 14.03.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit
import DropDown

class SettingsVC: UIViewController {
    
    @IBOutlet weak var genreDropButton: UIButton!
    @IBOutlet weak var gifDropButton: UIButton!
    @IBOutlet weak var iterationDropButton: UIButton!
    
    let genreDown = DropDown()
    let gifDown = DropDown()
    let iterationDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialization()
    }
    @IBAction func goToMainVC(_ sender: UIButton) {
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MainVC") as! ViewController
            self.navigationController?.pushViewController(vc, animated: false)
            //self.navigationController?.present(vc, animated: false, completion: nil)
            
            UIView.setAnimationTransition(UIViewAnimationTransition.curlDown, for: self.navigationController!.view!, cache: false)
        })
    }
    @IBAction func showGenreDropDown(_ sender: UIButton) {
        genreDown.show()
    }
    @IBAction func showGifDropDown(_ sender: UIButton) {
        gifDown.show()
    }
    @IBAction func showIterationDropDown(_ sender: UIButton) {
        iterationDown.show()
    }
}
