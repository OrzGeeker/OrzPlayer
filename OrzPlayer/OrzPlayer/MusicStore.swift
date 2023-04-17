//
//  MusicStore.swift
//  MusicStore
//
//  Created by joker on 2021/7/18.
//

import Foundation
import FModAPI

final class MusicStore: ObservableObject {
    
    @Published var musicItems = MusicInfoNode.parseMusics()
    
    private let player = FModCapsule()
    
}

struct MusicInfoNode: Codable {
    
    enum NodeType: String, Codable {
        case directory
        case file
        case report
    }
    
    let type: NodeType
     
    let name: String?
    
    let contents: [MusicInfoNode]?
    
    let directories: Int?
    
    let files: Int?
    
}

extension MusicInfoNode: Identifiable {
    var id: UUID { UUID() }
}


extension MusicInfoNode {
    static func parseMusics() -> [MusicInfoNode] {
        var ret = [MusicInfoNode]()
        guard let fileURL = Bundle.main.url(forResource: "music", withExtension: "json"),
              let data = try? Data(contentsOf: fileURL),
              let infos = try? JSONDecoder().decode([MusicInfoNode].self, from: data)
        else {
            return ret
        }
        ret = infos
        return ret
    }
}
