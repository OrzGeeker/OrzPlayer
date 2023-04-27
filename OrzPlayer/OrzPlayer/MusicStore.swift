//
//  MusicStore.swift
//  MusicStore
//
//  Created by joker on 2021/7/18.
//

import Foundation
import FModAPI

final class MusicStore: ObservableObject {
    
    var musicRootItem: MusicInfoNode? { MusicInfoNode.parseMusics().first { $0.type != .report } }
    
    private let player = FModCapsule()
    
}
