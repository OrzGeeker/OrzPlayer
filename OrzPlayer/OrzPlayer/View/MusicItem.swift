//
//  MusicItem.swift
//  MusicItem
//
//  Created by joker on 2021/7/18.
//

import SwiftUI

struct MusicItem: View {
    let name: String
    let detail: String
    let disclosure: String?
    
    var active = false
    
    @State private var rotateDegrees: Double = 0
    @State private var noteColor: Color = .red
    
    var body: some View {
        HStack {
            if active {
                Image(systemName: "music.note.list")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(noteColor)
                    .padding([.trailing], 10)
                    .rotationEffect(.degrees(rotateDegrees))
                    .animation(.easeInOut(duration: 0.5).repeatForever(), value: rotateDegrees)
                    .onAppear {
                        rotateDegrees = 45
                        noteColor = .green
                    }
            }
            VStack(alignment: .leading) {
                Text(name)
                    .fontWeight(active ? .bold : .medium)
                    .font(.system(size: 14))
                Text(detail)
                    .font(.system(size: 12))
            }
            Spacer()
            if let disclosure = disclosure {
                HStack {
                    Text(disclosure)
                    Image(systemName: "chevron.right")
                }
            }
        }
    }
}

struct MusicItem_Previews: PreviewProvider {
    static var previews: some View {
        MusicItem(
            name: "Music Name",
            detail: "Detail",
            disclosure: "Disclosure",
            active: true)
        .padding()
    }
}
