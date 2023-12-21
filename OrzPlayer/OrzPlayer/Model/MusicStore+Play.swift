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
        
        guard node.type == .file,
              node.downloaded
        else {
            return
        }

        if MusicStore.player.isPlaying(), MusicStore.player.isSame(as: node.playFilePath) {
            MusicStore.player.stop()
        } else {
            MusicStore.player.playStream(withFilePath: node.playFilePath)
        }
        
        selectedMusic = node
    }
}
