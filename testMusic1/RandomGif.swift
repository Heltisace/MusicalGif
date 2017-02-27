//
//  RandomGif.swift
//  testMusic1
//
//  Created by Heltisace on 23.02.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class RandomGif{
    //Get some random gif without preferences
    func getRandomGif() -> String{
        let url = URL(string: "http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC")
        var gif = ""
        
        if let data = try? Data(contentsOf: url!) {
            let tempJson = JSON(data: data)
            
            if let theGif = tempJson["data"]["image_original_url"].string {
                gif = theGif
            } else {gif = "http://media4.giphy.com/media/xUySTRGWPdx7oxnswU/giphy.gif"}
        }
        return gif
    }
}
