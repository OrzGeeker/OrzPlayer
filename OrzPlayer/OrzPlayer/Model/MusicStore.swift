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
        
        guard let rootNode = rootNode
        else {
            return
        }
        
        parseRootNode(rootNode)
    }
    
    func parseRootNode(_ node: MusicInfoNode) {
        
        guard let contents = node.contents
        else {
            return
        }
    
        for var content in contents {
            switch content.type {
            case .file:
                if  let name = content.name,
                    let playFilePath = MusicStore.documentationDirURL?.appending(path: name).path(percentEncoded: false) {
                    content.playFilePath = playFilePath
                }
                allMusics.append(content)
            case .directory:
                parseRootNode(content)
            case .report:
                allMusics.append(content)
            }
        }
    }
    
    static let documentationDirURL: URL? = try? FileManager.default.url(for: .documentationDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    
}
