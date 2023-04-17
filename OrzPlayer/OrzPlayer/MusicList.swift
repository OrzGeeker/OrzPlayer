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
            List {
                ForEach(store.musicItems) { item in
                    MusicItem(
                        name: item.name ?? "",
                        detail: item.type.rawValue,
                        disclosure: nil)
                }
            }
            .navigationBarTitle("OrzPlayer")
        }
    }
}

struct MusicListView_Previews: PreviewProvider {
    static var previews: some View {
        MusicList()
    }
}
