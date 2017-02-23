//
//  ViewController.swift
//  testMusic1
//
//  Created by Heltisace on 20.02.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var theGif: FLAnimatedImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var songInfoLabel: UILabel!
    
    let musicEngine = MusicEngine()
    let randomSongEngine = RandomSong()
    let randomGifEngine = RandomGif()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Playing a random song
        randomSongEngine.playRandomSong(musicEngine: musicEngine, randomSongEngine: randomSongEngine, infoLabel: songInfoLabel)
        
        //Play random gif
        randomGifEngine.playRandomGif(gifView: theGif, randomGifEngine: randomGifEngine)
    }
    
    @IBAction func tryButton(_ sender: UIButton) {
        
        //Playing a random song
        randomSongEngine.playRandomSong(musicEngine: musicEngine, randomSongEngine: randomSongEngine, infoLabel: songInfoLabel)
        
        //Play random gif
        randomGifEngine.playRandomGif(gifView: theGif, randomGifEngine: randomGifEngine)
    }
}
