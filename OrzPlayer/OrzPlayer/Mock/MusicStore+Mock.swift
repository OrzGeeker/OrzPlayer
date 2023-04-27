//
//  MusicStore+Mock.swift
//  OrzPlayer
//
//  Created by joker on 2023/4/27.
//

import Foundation

extension MusicStore {
    static let mockRootNode: MusicInfoNode?  = {
        parseMusics().first { $0.type != .report }
    }()
    
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
}
