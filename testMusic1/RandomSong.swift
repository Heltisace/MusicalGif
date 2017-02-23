//
//  RandomSong.swift
//  testMusic1
//
//  Created by Heltisace on 22.02.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit
import SwiftyJSON

class RandomSong{
    //Creating a random song request
    func getJsonUrl() -> String{
        //Array from a to z
        let filterArray = Array(97...122).map {String(UnicodeScalar($0))}
        //Array of max offset
        var maxRandom = Array(repeating: 100_000, count: 26)
        
        maxRandom[6] = 72_303
        maxRandom[16] = 23_285
        maxRandom[22] = 64_644
        maxRandom[25] = 62_642
        
        //Preparation to generate
        let randomIndex = Int(arc4random_uniform(UInt32(filterArray.count)))
        let filter = filterArray[randomIndex]
        let getRandomOffset = Int(arc4random_uniform(UInt32(maxRandom[randomIndex])))
        
        //Generation
        let url = "https://api.spotify.com/v1/search?query=\(filter)&offset=\(getRandomOffset)&limit=1&type=track&market=NL"
        
        return url
    }
    
    //Put json to variable
    func getSongJson(jsonUrl: String) -> JSON{
        
        let url = URL(string: jsonUrl)!
        var songJson: JSON?
        
        //Get the song url
        if let data = try? Data(contentsOf: url) {
            let tempJson = JSON(data: data)
            
            //Wait for downloading
            sleep(UInt32(0.5))
            songJson = tempJson
        }
        return songJson!
    }
    
    //Get the song url
    func getSongUrl(data: JSON) -> String{
        var trackUrl = "Nill"
        
        if let songUrl = data["tracks"]["items"][0]["preview_url"].string {
            trackUrl = songUrl
        } else {print("ERROR")}
        
        return trackUrl
    }
    
    //Get the song name
    func getSongName(data: JSON) -> String{
        var name = "Nill"
        
        if let songName = data["tracks"]["items"][0]["name"].string {
            name = songName
        } else {print("ERROR")}
        
        return name
    }
    
    //Get the song artist
    func getSongArtist(data: JSON) -> String{
        var artist = "Nill"
        
        if let songArtist = data["tracks"]["items"][0]["artists"][0]["name"].string {
            artist = songArtist
        } else {print("ERROR")}
        
        return artist
    }
    
    //Play a random song
    func playRandomSong(musicEngine: MusicEngine, randomSongEngine: RandomSong, infoLabel: UILabel){
        //Generating a random song
        let jsonUrl = randomSongEngine.getJsonUrl()
        let songJson = randomSongEngine.getSongJson(jsonUrl: jsonUrl)
        
        //Playing the random song
        musicEngine.playSound(soundUrl: randomSongEngine.getSongUrl(data: songJson))
        infoLabel.text! = randomSongEngine.getSongName(data: songJson)+" - "+randomSongEngine.getSongArtist(data: songJson)
    }
}
