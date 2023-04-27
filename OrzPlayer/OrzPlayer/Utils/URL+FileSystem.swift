//
//  URL+FileSystem.swift
//  OrzPlayer
//
//  Created by joker on 2023/4/27.
//

import Foundation

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
