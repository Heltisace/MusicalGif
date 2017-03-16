//
//  SettingsVCFunctions.swift
//  testMusic1
//
//  Created by Heltisace on 14.03.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit
import DropDown

extension SettingsVC {
    func createDropDown(view: UIView, dropDown: DropDown, list: [String]) {
        dropDown.anchorView = view
        dropDown.dataSource = list
        dropDown.direction = .bottom
    }
    
    func initialization() {
        createDropDown(view: genreDropButton, dropDown: genreDown, list: ["Demonstation","Rock","Pop"])
        createDropDown(view: gifDropButton, dropDown: gifDown, list: ["Demonstration","Full random", "Custom"])
        createDropDown(view: iterationDropButton, dropDown: iterationDown, list: ["Yes", "No"])
        
        genreDown.selectRow(at: 0)
        gifDown.selectRow(at: 0)
        iterationDown.selectRow(at: 0)
        
        genreDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.genreDropButton.setTitle(item, for: .normal )
        }
        gifDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.gifDropButton.setTitle(item, for: .normal )
        }
        iterationDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.iterationDropButton.setTitle(item, for: .normal )
        }
    }
}
