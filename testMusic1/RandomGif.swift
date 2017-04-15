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

class RandomGif {
    func randomTag() -> String {
        var funnyTags: [String] = ["animated", "fail", "animation", "whoops", "funny%20videos", "dancing", "music", "#", "cat"]

        let randomIndex = Int(arc4random_uniform(UInt32(funnyTags.count)))
        let randomTag = String(funnyTags[randomIndex])!

        return randomTag
    }
    //Get some random gif with preferences
    func getGifWithTag(tag: String) -> String {
        let stringUrl = "http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=\(tag)"
        var gif = ""

        if let url = URL(string: stringUrl) {
            if let data = try? Data(contentsOf: url) {
                let tempJson = JSON(data: data)
                if tempJson != JSON.null {
                    if let theGif = tempJson["data"]["image_original_url"].string {
                        gif = theGif
                    } else {gif = "Error"}
                } else {
                    gif = "Error"
                }
            } else {gif = "Error"}
        } else {gif = "Error"}

        return gif
    }
}
