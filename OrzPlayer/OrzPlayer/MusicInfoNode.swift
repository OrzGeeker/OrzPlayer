//
//  MusicInfoNode.swift
//  OrzPlayer
//
//  Created by joker on 2023/4/27.
//

import Foundation

struct MusicInfoNode: Codable, Identifiable, Hashable {
    
    var id = UUID()
    
    enum NodeType: String, Codable {
        case directory
        case file
        case report
    }
    
    let type: NodeType
    
    let name: String?
    
    var contents: [MusicInfoNode]?
    
    var directories: Int?
    
    var files: Int?
    
    var playFilePath: String?
    
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



