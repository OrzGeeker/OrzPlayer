//
//  MusicStore+Play.swift
//  OrzPlayer
//
//  Created by joker on 2023/12/21.
//

import Foundation
import FModAPI

extension MusicStore {
    
    private static let player = FModCapsule()
    
    func playFileNode(_ node: MusicInfoNode) {
        
        guard node.type == .file else {
            return
        }
        
        guard let playFilePath = node.playFilePath,
              FileManager.default.fileExists(atPath: playFilePath)
        else {
            return
        }
        
        if MusicStore.player.isPlaying(), MusicStore.player.isSame(as: playFilePath) {
            MusicStore.player.stop()
        } else {
            MusicStore.player.playStream(withFilePath: playFilePath)
        }
        
        selectedMusic = node
    }
}
