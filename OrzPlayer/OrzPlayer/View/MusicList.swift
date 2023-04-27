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
        VStack {
            HStack {
                if let uiIconImage = Bundle.appIcon {
                    Image(uiImage: uiIconImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                        .cornerRadius(8)
                }
                Text(Bundle.appName)
                    .bold()
                    .font(.largeTitle)
            }
            ScrollView(.vertical, showsIndicators: true) {
                if let root = store.rootNode {
                    OutlineGroup(root, children: \.contents) { item in
                        MusicItem(
                            name: item.description,
                            detail: item.detail,
                            disclosure: nil)
                        .onTapGesture {
                            store.playFileNode(item)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct MusicListView_Previews: PreviewProvider {
    static var previews: some View {
        MusicList()
            .environmentObject(MusicStore())
    }
}
