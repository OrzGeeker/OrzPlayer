//
//  MusicList.swift
//  OrzPlayer
//
//  Created by joker on 2021/7/18.
//

import SwiftUI

struct MusicList: View {
    
    @Environment(MusicStore.self) var store
    
    @State var outlineMode = false
    
    @State private var iconRotateDegress: Double = 0
    
    var body: some View {
        VStack {
            HStack {
                if let uiIconImage = Bundle.appIcon {
                    Image(uiImage: uiIconImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                        .cornerRadius(20)
                        .rotationEffect(.degrees(iconRotateDegress))
                        .animation(
                            .linear(duration: 5)
                            .repeatForever(autoreverses: false),
                            value: iconRotateDegress
                        )
                        .padding([.trailing], 5)
                        .onAppear {
                            iconRotateDegress = 360
                        }
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
                                if item.downloaded {
                                    store.playFileNode(item)
                                } else {
                                    Task {
                                        do {
                                            let ret = try await store.fetchPlayFile(with: item)
                                        } catch {
                                            
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                } else {
                    List(store.allMusics) { item in
                        MusicItem(
                            name: item.description,
                            detail: item.detail,
                            disclosure: nil,
                            active: store.selectedMusic?.id == item.id)
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            Task {
                                if item.downloaded {
                                    store.playFileNode(item)
                                } else {
                                   try await store.fetchPlayFile(with: item)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            else {
                EmptyView()
            }
            Spacer()
        }
        .overlay(alignment: .topTrailing) {
            if !store.allMusics.isEmpty {
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
        .task {
            do {
                try await store.loadRootNode()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview("Music List") {
    MusicList()
        .environment(MusicStore())
}
