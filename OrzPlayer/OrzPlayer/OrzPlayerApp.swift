//
//  OrzPlayerApp.swift
//  OrzPlayer
//
//  Created by joker on 2021/7/18.
//

import SwiftUI
import FModAPI

@main
struct OrzPlayerApp: App {
    let player = FModCapsule()
    var body: some Scene {
        WindowGroup {
            MusicList()
                .onAppear {
                    player.playDemoMusic()
                }
        }
    }
}
