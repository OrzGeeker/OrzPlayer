//
//  MusicInfoNode.swift
//  OrzPlayer
//
//  Created by joker on 2023/4/27.
//

import Foundation


enum NodeType: String, Codable {
    case directory
    case file
    case report
}

struct MusicInfoNode: Codable, Identifiable, Hashable {

    let type: NodeType
    
    let name: String?

    var contents: [MusicInfoNode]?

    var directories: Int?

    var files: Int?

    var playFilePath: String?

    var bytes: Int64?

    // MARK: Identifiable 实现不可以做成getter
    let id = UUID()

    enum CodingKeys: String, CodingKey {
        case type
        case name
        case contents
        case directories
        case files
        case playFilePath
        case bytes = "size"
    }
}

extension MusicInfoNode {
    
    var kiloBytes: Int64 {
        
        guard let bytes = bytes
        else{
            return 0
        }
        
        return bytes / 1024
    }
     
    var megaBytes: Int64 {
        return kiloBytes / 1024
    }
    
    var downloaded: Bool {
        
        guard let playFilePath,
              FileManager.default.fileExists(atPath: playFilePath)
        else {
            return false
        }
        
        return true
    }
}

extension MusicInfoNode: CustomStringConvertible {
    
    var description: String {
        
        var ret = ""
        
        if let name = name {
            ret = name.lastPathComponent
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
            ret = "\(kiloBytes) KB"
        case .directory:
            ret = "\(contents?.count ?? 0) items"
        case .report:
            break
        }
        
        return ret
    }
}
