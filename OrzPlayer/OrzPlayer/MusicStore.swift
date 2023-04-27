//
//  MusicStore.swift
//  MusicStore
//
//  Created by joker on 2021/7/18.
//

import Foundation
import FModAPI

final class MusicStore: ObservableObject {
    
    var musicRootItem: MusicInfoNode? { MusicInfoNode.parseMusics().first { $0.type != .report } }
    
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

extension MusicInfoNode: CustomStringConvertible {
    
    var description: String {
        
        var ret = ""
        
        if let name = name {
            ret = name
        }
        
        switch type {
        case .file:
            break
        case .directory:
            ret += "/"
        case .report:
            return "\(directories ?? 0) dirs, \(files ?? 0) files"
        }
        
        return ret
    }
}

extension MusicInfoNode: Identifiable, Hashable {
    var id: Self { self }
}


extension MusicInfoNode {
    static func parseMusics() -> [MusicInfoNode] {
        var ret = [MusicInfoNode]()
        
        /// 可使用命令行工具生成文件系统结构数据JSON文件
        ///
        /// ```bash
        /// brew install tree
        /// tree . -J
        /// ```
        ///
        guard let fileURL = Bundle.main.url(forResource: "music", withExtension: "json"),
              let data = try? Data(contentsOf: fileURL),
              let infos = try? JSONDecoder().decode([MusicInfoNode].self, from: data)
        else {
            return ret
        }
        ret = infos
        return ret
    }
    
    var detail: String {
        
        var ret = ""
        
        switch type {
        case .file:
            break
        case .directory:
            ret = "\(contents?.count ?? 0) items"
        case .report:
            break
        }
        
        return ret
    }
}
