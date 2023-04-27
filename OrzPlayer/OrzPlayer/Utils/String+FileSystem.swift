//
//  String+FileSystem.swift
//  OrzPlayer
//
//  Created by joker on 2023/4/27.
//

import Foundation

extension String {
    
    var isFilePath: Bool { URL(filePath: self).isFile }
    
    var isDirPath: Bool { URL(filePath: self).isDir }
    
    var lastPathComponent: String { return NSString(string: self).lastPathComponent }
    
    func appendingPathComponent(_ path: String) -> String { NSString.path(withComponents: [self, path]) }
}
