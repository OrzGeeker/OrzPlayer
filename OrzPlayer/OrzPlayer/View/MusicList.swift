//
//  MusicList.swift
//  OrzPlayer
//
//  Created by joker on 2021/7/18.
//

import SwiftUI

struct MusicList: View {
    
    @EnvironmentObject var store: MusicStore
    
    @State var outlineMode = false
    
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
            if let root = store.rootNode {
                if outlineMode {
                    ScrollView(.vertical, showsIndicators: true) {
                        OutlineGroup(root, children: \.contents) { item in
                            MusicItem(
                                name: item.description,
                                detail: item.detail,
                                disclosure: nil,
                                active: store.selectedMusic?.id == item.id)
                            .onTapGesture {
                                store.playFileNode(item)
                            }
                        }
                        .padding(.horizontal)
                    }
                } else {
                    List(MusicStore.allMusics) { item in
                        MusicItem(
                            name: item.description,
                            detail: item.detail,
                            disclosure: nil,
                            active: store.selectedMusic?.id == item.id)
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            store.playFileNode(item)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            else {
                EmptyView()
            }
        }
        .overlay(alignment: .topTrailing) {
            Button {
                outlineMode.toggle()
            } label: {
                Image(systemName: outlineMode ? "list.triangle" : "text.alignleft")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            .padding([.top], 10)
            .padding([.trailing], 15)
        }
    }
}

struct MusicListView_Previews: PreviewProvider {
    static var previews: some View {
        MusicList()
            .environmentObject(MusicStore())
    }
}
