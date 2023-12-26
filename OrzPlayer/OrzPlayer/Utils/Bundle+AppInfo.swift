//
//  Bundle+AppInfo.swift
//  OrzPlayer
//
//  Created by joker on 2023/4/27.
//

import Foundation
import SwiftUI

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

extension Bundle {
    
    static let appName: String = {
        guard let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String else {
            return ""
        }
        return bundleName
    }()
    
    static let appIconName: String? = {
        guard let bundleIconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIconsDictionary = bundleIconsDictionary["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? [Any],
              let lastIconName = iconFiles.last as? String
        else {
            return nil
        }
        return lastIconName
    }()

    static let appIconImage: Image? = {
        guard let appIconName
        else {
            return nil
        }

#if canImport(AppKit)
        if let nsImage = NSImage(named: appIconName) {
            return Image(nsImage: nsImage)
        }
#elseif canImport(UIKit)
        if let uiImage = UIImage(named: appIconName) {
            return Image(uiImage: uiImage)
        }
#else

#endif
        return nil
    }()
}
