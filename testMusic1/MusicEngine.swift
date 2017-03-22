//
//  MusicEngine.swift
//  testMusic1
//
//  Created by Heltisace on 20.02.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit
import AVFoundation

class MusicEngine {
    var player: AVPlayer?
    init() {
        player = AVPlayer()
    }
    
    func loadTrack(soundUrl: String) {
        if let url = NSURL(string: soundUrl) {
            player = AVPlayer(url: url as URL)
            player?.volume = 1.0
        }
    }
    
    func playTrack(viewController: ViewController) {
        player?.play()
        //Loop or next
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: nil, using: { (_) in
            DispatchQueue.main.async {
                if viewController.preSetIteration == "Yes" {
                    //Loop
                    self.player?.seek(to: kCMTimeZero)
                    self.player?.play()
                } else {
                    if !viewController.processIsWorking {
                        //Next set
                        viewController.startTheShow()
                    }
                }
            }
        })
    }
    
    func stopPlaying() {
        player?.pause()
        player?.cancelPendingPrerolls()
    }
    
    func deletePlayer() {
        player = nil
    }
}
