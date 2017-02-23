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
            
            //Wait for downloading
            sleep(UInt32(0.5))
            
            if let theGif = tempJson["data"]["image_original_url"].string {
                gif = theGif
            } else {print("ERROR")}
        }
        return gif
    }
    func playRandomGif(gifView: FLAnimatedImageView, randomGifEngine: RandomGif){
        //Generate a random gif
        let gif = randomGifEngine.getRandomGif()
        //Play the random gif
        gifView.sd_setImage(with: URL(string: gif))
    }
}
