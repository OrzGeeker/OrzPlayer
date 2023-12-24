//
//  MusicStore+Remote.swift
//  OrzPlayer
//
//  Created by joker on 2023/12/21.
//

import Foundation

extension MusicStore {
    
    static let baseURL = URL(string: "http://127.0.0.1:8080")

    func fetchKeyGenMusicList() async throws -> MusicInfoNode? {
        
        guard let requestURL = URL(string: "/musics/list", relativeTo: MusicStore.baseURL)
        else {
            return nil
        }
        
        let (data, response) = try await URLSession.shared.data(from: requestURL)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200
        else {
            return nil
        }
        
        let root = try JSONDecoder().decode([MusicInfoNode].self, from: data).first
        return root
    }
    	
    @discardableResult
    func fetchPlayFile(with node: MusicInfoNode) async throws -> Bool {
        
        guard let playFilePath = node.playFilePath,
              let filePath = node.name,
              let requestURL = URL(string: filePath, relativeTo: MusicStore.baseURL)
        else {
            return false
        }

        let (data, response) = try await URLSession.shared.data(from: requestURL)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200
        else {
            return false
        }

        let fileURL = URL(filePath: playFilePath)
        if !FileManager.default.fileExists(atPath: playFilePath) {
            try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        }
        try data.write(to: fileURL, options: .atomic)

        return true
    }
}
