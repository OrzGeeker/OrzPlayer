//
//  MusicList.swift
//  OrzPlayer
//
//  Created by joker on 2021/7/18.
//

import SwiftUI

struct MusicList: View {
    var body: some View {
        NavigationView {
            List(1..<20) { itme in
                MusicItem()
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
