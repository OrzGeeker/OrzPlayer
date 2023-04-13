//
//  MusicItem.swift
//  MusicItem
//
//  Created by joker on 2021/7/18.
//

import SwiftUI

struct MusicItem: View {
    var body: some View {
        HStack {
            Image(systemName: "play.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 50)
                .padding(.vertical, 10)
            
            Text("Music Title")
                .fontWeight(.bold)
                .font(.title)
            
            Spacer()
        }

        
    }
}

struct MusicItem_Previews: PreviewProvider {
    static var previews: some View {
        MusicItem()
    }
}
