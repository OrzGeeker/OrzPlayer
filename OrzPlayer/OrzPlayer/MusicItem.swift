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
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .fontWeight(.bold)
                    .font(.title)
                Text(detail)
            }
            Spacer()
            HStack {
                if let disclosure = disclosure {
                    Text(disclosure)
                }
                Image(systemName: "chevron.right")
            }
        }

        
    }
}

struct MusicItem_Previews: PreviewProvider {
    static var previews: some View {
        MusicItem(
            name: "Music Name",
            detail: "Detail",
            disclosure: "Disclosure").padding()
    }
}
