//
//  MusicStore.swift
//  MusicStore
//
//  Created by joker on 2021/7/18.
//

import Foundation
import FModAPI

final class MusicStore: ObservableObject {
    
    private let player = FModCapsule()
    
    let rootNode: MusicInfoNode? = try? MusicStore.walkThroughDocumentDir()
    
    func playFileNode(_ node: MusicInfoNode) {
        
        guard node.type == .file else {
            return
        }
        
        player.playStream(withFilePath: node.playFilePath)
    }
    
    static var allMusics = [MusicInfoNode]()
}

extension MusicStore {
    
    static let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    
    static func walkThroughDocumentDir() throws -> MusicInfoNode {
        
        enum FileSystemError: Error {
            case documentDirNotExist
        }
        
        guard let documentDir = documentDir
        else {
            throw FileSystemError.documentDirNotExist
        }
        
        var root = MusicInfoNode(
            type: .directory,
            name: documentDir.lastPathComponent,
            contents: nil,
            directories: nil,
            files: nil)
        
        try walkThroughFilePath(documentDir, parent: &root)
        
        return root
    }
    
    static func walkThroughFilePath(_ filePath: String?, parent: inout MusicInfoNode) throws {
        
        guard let filePath = filePath else {
            return
        }
        
        if filePath.isDirPath {
            
            var parentFileCount = 0
            var parentDirCount = 0
            var parentContents = [MusicInfoNode]()
            
            for item in try FileManager.default.contentsOfDirectory(atPath: filePath) {
                
                let newFilePath = filePath.appendingPathComponent(item)
                
                var nodeType: MusicInfoNode.NodeType = .directory
                
                if newFilePath.isDirPath {
                    parentDirCount += 1
                    nodeType = .directory
                } else if newFilePath.isFilePath {
                    parentFileCount += 1
                    nodeType = .file
                }
                
                var node = MusicInfoNode(
                    type: nodeType,
                    name: item,
                    contents: nil,
                    directories: nil,
                    files: nil)
                
                try walkThroughFilePath(newFilePath, parent: &node)
                
                parentContents.append(node)
            }
            
            parent.files = parentFileCount
            parent.directories = parentDirCount
            parent.contents = parentContents
            
        } else if filePath.isFilePath {
            
            let fileNode = MusicInfoNode(
                type: .file,
                name: filePath.lastPathComponent,
                contents: nil,
                directories: nil,
                files: nil,
                playFilePath: filePath
            )
            
            parent = fileNode
            
            allMusics.append(fileNode)
        }
    }
}
