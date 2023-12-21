//
//  MusicStore+Local.swift
//  OrzPlayer
//
//  Created by joker on 2023/12/21.
//

import Foundation


extension MusicStore {
    
    func walkThroughBundleDir() throws -> MusicInfoNode? {
        
        guard
            var root = MusicStore.bundleRootNode,
            let musicDirRoot = MusicStore.bundleMusicDirRoot
        else {
            return nil
        }
        
        try walkThroughFilePath(musicDirRoot, parent: &root)
        
        return root
    }
}

extension MusicStore {
    
    static let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    
    func walkThroughDocumentDir() throws -> MusicInfoNode {
        
        enum FileSystemError: Error {
            case documentDirNotExist
        }
        
        guard let documentDir = MusicStore.documentDir
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
    
    func walkThroughFilePath(_ filePath: String?, parent: inout MusicInfoNode) throws {
        
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
                playFilePath: filePath,
                bytes: try FileManager.default.attributesOfItem(atPath: filePath)[FileAttributeKey.size] as? Int64
            )
            
            parent = fileNode
            
            allMusics.append(fileNode)
        }
    }
}
