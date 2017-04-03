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
    func getJsonUrlWithGenre(genre: String) -> String {
        var url = ""
        DispatchQueue.global().sync {
            //Generation
            let randomOffset = getRandomGenreOffset(genre: genre)
            
            url = "https://api.spotify.com/v1/search?type=track&limit=1&offset=\(randomOffset)&q=genre:%22\(genre)%22&market=NL"
        }
        return url
    }
    
    func getJsonUrlWithABC() -> String {
        //Array from a to z
        let filterArray = Array(97...122).map {String(UnicodeScalar($0))}
        //Preparation to generate
        let randomIndex = Int(arc4random_uniform(UInt32(filterArray.count)))
        let filter = filterArray[randomIndex]
        let getRandomOffset = self.getRandomABCOffset(letter: filter)
        //Generation
        let url = "https://api.spotify.com/v1/search?query=\(filter)&offset=\(getRandomOffset)&limit=1&type=track&market=NL"
        
        return url
    }
    func getRandomGenre() -> String {
        var filter = ""
        DispatchQueue.global().sync {
            //Array from a to z
            let filterArray: [String] = ["Trance", "Electronic", "Hip%20Hop", "Rap", "Remix", "Pop"]
            //Preparation to generate
            let randomIndex = Int(arc4random_uniform(UInt32(filterArray.count)))
            filter = filterArray[randomIndex]
        }
        return filter
    }
    
    func getRandomGenreOffset(genre: String) -> String {
        var randomOffset = "0"
        DispatchQueue.global().sync {
            let url = "https://api.spotify.com/v1/search?type=track&limit=1&offset=\(0)&q=genre:%22\(genre)%22&market=NL"
            let tempData = getSongJson(jsonUrl: url)
            let maxOffset = getTotalNumberOfSongs(data: tempData)
            
            randomOffset = String(arc4random_uniform(UInt32(maxOffset)!))
        }
        return randomOffset
    }
    
    func getRandomABCOffset(letter: String) -> String {
        var randomOffset = "0"
        DispatchQueue.global().sync {
            let url = "https://api.spotify.com/v1/search?type=track&limit=1&offset=\(0)&q=\(letter)&market=NL"
            let tempData = getSongJson(jsonUrl: url)
            let maxOffset = getTotalNumberOfSongs(data: tempData)
            
            randomOffset = String(arc4random_uniform(UInt32(maxOffset)!))
        }
        return randomOffset
    }
    
    //Put json to variable
    func getSongJson(jsonUrl: String) -> JSON? {
        var songJson: JSON?
        //Get the song url
        if let url = URL(string: jsonUrl) {
            if let data = try? Data(contentsOf: url) {
                let tempJson = JSON(data: data)
                //Wait for downloading
                songJson = tempJson
            }
        }
        return songJson
    }
    
    //Put json to variable 2
    func getSongJsonWithID(songID: String) -> JSON? {
        var songJson: JSON?
        let jsonUrl = "https://api.spotify.com/v1/tracks/\(songID)"
        //Get the song url
        if let url = URL(string: jsonUrl) {
            if let data = try? Data(contentsOf: url) {
                let tempJson = JSON(data: data)
                //Wait for downloading
                songJson = tempJson
            }
        }
        return songJson
    }
    
    //Get the song url
    func getSongUrl(data: JSON) -> String {
        var trackUrl = "Nill"
        
        if let songUrl = data["tracks"]["items"][0]["preview_url"].string {
            trackUrl = songUrl
        } else {print("ERROR")}
        return trackUrl
    }
    
    //Get the song name
    func getSongName(data: JSON) -> String {
        var name = "Nill"
        if let songName = data["tracks"]["items"][0]["name"].string {
            name = songName
        } else {print("ERROR")}
        return name
    }
    
    //Get the song artist
    func getSongArtist(data: JSON) -> String {
        var artist = "Nill"
        if let songArtist = data["tracks"]["items"][0]["artists"][0]["name"].string {
            artist = songArtist
        } else {print("ERROR")}
        return artist
    }
    
    func getTotalNumberOfSongs(data: JSON?) -> String {
        var total = "0"
        if let maxOffset = data?["tracks"]["total"].int {
            total = String(maxOffset)
        }
        if Int(total)! > 100_000 {
            total = "100000"
        }
        return total
    }
    
    //Load a random song
    func generateRandomSong(musicEngine: MusicEngine, randomSongEngine: RandomSong, genre: String) -> [String] {
        //Stop playing previous song
        musicEngine.stopPlaying()
        //Generating a random song
        if genre != "" {
            jsonUrl = randomSongEngine.getJsonUrlWithGenre(genre: genre)
        } else {
            jsonUrl = randomSongEngine.getJsonUrlWithABC()
        }
        songJson = randomSongEngine.getSongJson(jsonUrl: jsonUrl)
        trackURL = randomSongEngine.getSongUrl(data: songJson!)
        
        songInfo = randomSongEngine.getSongName(data: songJson!)+" - "+randomSongEngine.getSongArtist(data: songJson!)
        
        return [trackURL,jsonUrl]
    }
    
    func generateSong(jsonUrl: String, musicEngine: MusicEngine, randomSongEngine: RandomSong) -> String {
        //Stop playing previous song
        musicEngine.stopPlaying()
        
        songJson = randomSongEngine.getSongJson(jsonUrl: jsonUrl)
        trackURL = randomSongEngine.getSongUrl(data: songJson!)
        songInfo = randomSongEngine.getSongName(data: songJson!)+" - "+randomSongEngine.getSongArtist(data: songJson!)
        
        return trackURL
    }
    
    func loadRandomSong(musicEngine: MusicEngine) {
        //Loading the random song
        musicEngine.loadTrack(soundUrl: trackURL)
    }
    
    func setSongInfo(infoLabel: UILabel) {
        //Set new song info
        infoLabel.text! = songInfo
    }
}
