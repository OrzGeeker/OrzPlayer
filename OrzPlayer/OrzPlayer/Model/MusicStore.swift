//
//  MusicStore.swift
//  MusicStore
//
//  Created by joker on 2021/7/18.
//

import Foundation
import FModAPI

@Observable
final class MusicStore {
    
//    let rootNode: MusicInfoNode? = try? MusicStore.walkThroughDocumentDir()
    
    let useLocal = false
    
    var rootNode: MusicInfoNode?
    
    var allMusics = [MusicInfoNode]()
    
    var selectedMusic: MusicInfoNode?
}

extension MusicStore {
    
    func loadRootNode() async throws {
        if useLocal {
            rootNode = try walkThroughBundleDir()
        } else {
            rootNode = try await fetchKeyGenMusicList()
        }
    }
}
