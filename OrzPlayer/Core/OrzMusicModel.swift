//
//  OrzMusicModel.swift
//  jokerHub
//
//  Created by joker on 2018/1/5.
//  Copyright © 2018年 joker. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Music {
    
    static let unPlayableFormat = ["json","nsf"]
    
    static let saveFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(OrzMusicRouter.musicListJsonFile)
    
    var report: Report?
    var root: Directory?
    
    init?(json: JSON) {
        if let first = json.arrayValue.first {
            root = Directory(json: first)
        }
        
        if let last = json.arrayValue.last {
            report = Report(json: last)
        }
    }
    
    static func readCacheMusicJSON() -> Music? {
        
        if let jsonString = try? String(contentsOf: saveFileURL, encoding: String.Encoding.utf8) {
            let json = JSON(parseJSON: jsonString)
            return Music(json:json)
        }
        return nil
    }
    
    static func requestMusicList( completion: @escaping (_ result: Music?) -> Void) {

        OrzMusicServices.shareInstance.GetMusicList { (response) in
            guard response.error == nil else {
                return
            }
            
            if let jsonString = response.value {
                try? jsonString.write(to: self.saveFileURL, atomically: true, encoding: String.Encoding.utf8)
                let json = JSON(parseJSON: jsonString)
                let music = Music(json: json)
                completion(music)
            }
        }
    }
}

struct Directory {
    var name: String?
    var contents: Array<Any>?
    
    init?(json: JSON) {
        
        if let type = json["type"].string, type == "directory" {
            name = json["name"].string
            
            if let childs = json["contents"].array {
                
                contents = [Any]()
                for child in childs {
                    
                    if let type = child["type"].string {
                        
                        if type == "directory" {
                            if let directory = Directory(json: child) {
                                contents?.append(directory)
                            }
                        }
                        
                        if type == "file" {
                            
                            if let file = File(json: child) {
                                contents?.append(file)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct Report {
    var directories:Int?
    var files: Int?
    
    init?(json: JSON) {
        if let type = json["type"].string, type == "report" {
            directories = json["directories"].int
            files = json["files"].int
        }
    }
}

struct File: Equatable {
    var name: String?
    var playable: Bool = true
    
    init?(json: JSON) {
        
        if let type = json["type"].string, type == "file" {
            name = json["name"].string
            
            if let fileExt = name?.split(separator: ".").last {
                playable = !Music.unPlayableFormat.contains(String(fileExt))
            }
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name && lhs.playable == rhs.playable
    }
}
