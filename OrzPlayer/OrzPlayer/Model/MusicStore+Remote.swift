//
//  MusicStore+Remote.swift
//  OrzPlayer
//
//  Created by joker on 2023/12/21.
//

import Foundation

extension MusicStore {
    
    func fetchKeyGenMusicList() async throws -> MusicInfoNode? {
        
        guard let requestURL = URL(string: "/musics/list", relativeTo: URL(string: "http://127.0.0.1:8080"))
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
}
