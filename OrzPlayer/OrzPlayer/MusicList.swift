//
//  MusicList.swift
//  OrzPlayer
//
//  Created by joker on 2021/7/18.
//

import SwiftUI

struct MusicList: View {
    
    @EnvironmentObject var store: MusicStore
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                if let root = store.musicRootItem {
                    OutlineGroup(root, children: \.contents) { item in
                        MusicItem(
                            name: item.description,
                            detail: item.detail,
                            disclosure: nil)
                    }
                }
            }
            .padding()
            .navigationBarTitle("OrzPlayer")
        }
    }
}

struct MusicListView_Previews: PreviewProvider {
    static var previews: some View {
        MusicList()
            .environmentObject(MusicStore())
    }
}
