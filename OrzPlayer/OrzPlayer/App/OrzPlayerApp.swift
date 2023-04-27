//
//  OrzPlayerApp.swift
//  OrzPlayer
//
//  Created by joker on 2021/7/18.
//

import SwiftUI

@main
struct OrzPlayerApp: App {
    var body: some Scene {
        WindowGroup {
            MusicList()
                .environmentObject(MusicStore())
        }
    }
}
