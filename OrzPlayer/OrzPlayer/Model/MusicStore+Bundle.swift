//
//  MusicStore+Mock.swift
//  OrzPlayer
//
//  Created by joker on 2023/4/27.
//

import Foundation

extension MusicStore {
    
    static let bundleRootNode: MusicInfoNode?  = {
        parseMusics().first { $0.type != .report }
    }()
    
    static let bundleMusicDirRoot: String? = {
        guard
            let musicBundlePath = Bundle.main.path(forResource: "OrzMusicBundle", ofType: "bundle", inDirectory: "PlugIns"),
            let musicBundle = Bundle(path: musicBundlePath)
        else {
            return nil
        }
        return musicBundle.bundlePath.appendingPathComponent("KeyGenMusic")
    }()
    
    static func parseMusics() -> [MusicInfoNode] {
        var ret = [MusicInfoNode]()
        guard
            let musicBundlePath = Bundle.main.path(forResource: "OrzMusicBundle", ofType: "bundle", inDirectory: "PlugIns"),
            let musicBundle = Bundle(path: musicBundlePath),
            let fileURL = musicBundle.url(forResource: "music", withExtension: "json", subdirectory: "KeyGenMusic"),
            let data = try? Data(contentsOf: fileURL),
            let infos = try? JSONDecoder().decode([MusicInfoNode].self, from: data)
        else {
            return ret
        }
        ret = infos
        return ret
    }
}
