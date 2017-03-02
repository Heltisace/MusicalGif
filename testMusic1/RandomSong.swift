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
    
    var jsonUrl = ""
    var songJson: JSON?
    var trackURL = ""
    var songInfo = ""
    
    //Creating a random song request
    func getJsonUrl() -> String{
        var url = ""
        DispatchQueue.global().sync{
            //Generation
            let random = getRandomGenreAndOffset()
            url = "https://api.spotify.com/v1/search?type=track&limit=1&offset=\(random[1])&q=genre:%22\(random[0])%22&market=NL"
        }
        return url
    }
    
    func getRandomGenreAndOffset() -> [String]{
        var filter = ""
        var offset = 0
        DispatchQueue.global().sync{
            //Array from a to z
            let filterArray: [String] = ["Trance", "Electronic", "Hip%20Hop", "Rap", "Remix", "Pop"]
            //Array of max offset
            var maxRandom = Array(repeating: 0, count: filterArray.count)
            
            maxRandom[0] = 86783
            maxRandom[1] = 70956
            maxRandom[2] = 85152
            maxRandom[3] = 87863
            maxRandom[4] = 6189
            maxRandom[5] = 71500
            
            //Preparation to generate
            let randomIndex = Int(arc4random_uniform(UInt32(filterArray.count)))
            filter = filterArray[randomIndex]
            offset = Int(arc4random_uniform(UInt32(maxRandom[randomIndex])))
        }
        return [filter, String(offset)]
    }
    
    //Put json to variable
    func getSongJson(jsonUrl: String) -> JSON{
        
        let url = URL(string: jsonUrl)!
        var songJson: JSON?
        
        //Get the song url
        if let data = try? Data(contentsOf: url) {
            let tempJson = JSON(data: data)
            
            //Wait for downloading
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
    
    //Load a random song
    func generateRandomSong(musicEngine: MusicEngine, randomSongEngine: RandomSong, infoLabel: UILabel) -> String{
        //Stop playing previous song
        musicEngine.stopPlaying()
        
        //Generating a random song
        jsonUrl = randomSongEngine.getJsonUrl()
        songJson = randomSongEngine.getSongJson(jsonUrl: jsonUrl)
        trackURL = randomSongEngine.getSongUrl(data: songJson!)
        songInfo = randomSongEngine.getSongName(data: songJson!)+" - "+randomSongEngine.getSongArtist(data: songJson!)
        
        return trackURL
    }
    func loadRandomSong(musicEngine: MusicEngine){
        //Loading the random song
        musicEngine.loadTrack(soundUrl: trackURL)
    }
    func loadSongInfo(infoLabel: UILabel){
        //Set new song info
        infoLabel.text! = songInfo
    }
}
