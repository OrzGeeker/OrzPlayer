//
//  MusicStore.swift
//  MusicStore
//
//  Created by joker on 2021/7/18.
//

import Foundation
import FModAPI
import UIKit

final class MusicStore: ObservableObject {
    
    private let player = FModCapsule()
    
    let rootNode: MusicInfoNode? = try? MusicStore.walkThroughDocumentDir()
    
    func playFileNode(_ node: MusicInfoNode) {
        
        guard node.type == .file else {
            return
        }
        
        player.playStream(withFilePath: node.playFilePath)
    }
}

enum FileSystemError: Error {
    case documentDirNotExist
}

extension MusicStore {
    
    static let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    
    static func walkThroughDocumentDir() throws -> MusicInfoNode {
        
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
            
            parent = MusicInfoNode(
                type: .file,
                name: filePath.lastPathComponent,
                contents: nil,
                directories: nil,
                files: nil,
                playFilePath: filePath
            )
        }
    }
    
}

extension URL {
    
    var isDir: Bool {
        
        guard self.isFileURL
        else {
            return false
        }
        
        var isDir = ObjCBool(false)
        
        let isFileExist = FileManager.default.fileExists(atPath: self.path, isDirectory: &isDir)
        
        return isFileExist && isDir.boolValue
    }
    
    var isFile: Bool {
        
        guard self.isFileURL
        else {
            return false
        }
        
        var isDir = ObjCBool(false)
        
        let isFileExist = FileManager.default.fileExists(atPath: self.path, isDirectory: &isDir)
        
        return isFileExist && !isDir.boolValue
    }
    
    var path: String { self.path(percentEncoded: false) }
    
}

extension String {
    
    var isFilePath: Bool { URL(filePath: self).isFile }
    
    var isDirPath: Bool { URL(filePath: self).isDir }
    
    var lastPathComponent: String { return NSString(string: self).lastPathComponent }
    
    func appendingPathComponent(_ path: String) -> String { NSString.path(withComponents: [self, path]) }
}


extension Bundle {
    
    static let appName: String = {
        guard let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String else {
            return ""
        }
        return bundleName
    }()
    
    static let appIcon: UIImage? = {
        guard let bundleIconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIconsDictionary = bundleIconsDictionary["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? [Any],
              let lastIcon = iconFiles.last as? String,
              let iconImage = UIImage(named: lastIcon)
        else {
            return nil
        }
        return iconImage
    }()

}
