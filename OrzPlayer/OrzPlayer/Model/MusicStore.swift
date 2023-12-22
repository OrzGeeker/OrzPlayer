//
//  MusicStore.swift
//  MusicStore
//
//  Created by joker on 2021/7/18.
//

import Foundation
import FModAPI

@Observable
final class MusicStore {

    let useLocal = false

    var rootNode: MusicInfoNode?

    var allMusics = [MusicInfoNode]()

    var selectedMusic: MusicInfoNode?
}

extension MusicStore {

    func loadRootNode() async throws {

        if useLocal {

            rootNode = try walkThroughBundleDir()

        } else {

            rootNode = try await fetchKeyGenMusicList()
        }

        guard let rootNode = rootNode
        else {
            return
        }

        allMusics = parseRootNode(rootNode)
    }

    func parseRootNode(_ node: MusicInfoNode) -> [MusicInfoNode] {

        var ret = [MusicInfoNode]()

        guard let contents = node.contents
        else {
            return ret
        }

        for var content in contents {

            switch content.type {
            case .file:
                if  let name = content.name,
                    let playFileURL = MusicStore.documentationDirURL?.appending(path: name) {
                    content.playFilePath = playFileURL.path(percentEncoded: false)
                }
                ret.append(content)
            case .directory:
                ret.append(contentsOf: parseRootNode(content))
            case .report:
                ret.append(content)
            }
        }

        return ret
    }

    static let documentationDirURL: URL? = try? FileManager.default.url(
        for: .documentationDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: true)

}
