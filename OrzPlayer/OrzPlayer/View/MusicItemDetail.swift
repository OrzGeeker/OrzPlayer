//
//  MusicItemDetail.swift
//  OrzPlayer
//
//  Created by joker on 2023/4/27.
//

import SwiftUI

struct MusicItemDetail: View {
    
    let item: MusicInfoNode
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview("Music Detail") {
    MusicItemDetail(item: MusicInfoNode(type: .file, name: "name"))
}
