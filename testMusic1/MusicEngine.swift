//
//  MusicEngine.swift
//  testMusic1
//
//  Created by Heltisace on 20.02.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit
import AVFoundation

class MusicEngine{
    var player = AVPlayer()
    func playSound(soundUrl: String){
        if let url = NSURL(string: soundUrl) {
            player = AVPlayer(url: url as URL)
            player.volume = 1.0
            player.play()
            
            //Loop
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: nil, using: { (_) in
                DispatchQueue.main.async {
                    self.player.seek(to: kCMTimeZero)
                    self.player.play()
                }
            })

        }
    }
}
