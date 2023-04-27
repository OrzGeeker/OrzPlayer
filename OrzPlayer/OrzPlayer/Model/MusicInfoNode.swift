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
