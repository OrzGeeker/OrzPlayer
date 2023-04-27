//
//  Bundle+AppInfo.swift
//  OrzPlayer
//
//  Created by joker on 2023/4/27.
//

import Foundation
import UIKit

extension Bundle {
    
    static let appName: String = {
        guard let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String else {
            return ""
        }
        return bundleName
    }()
    
    static let appIcon: UIImage? = {
        guard let bundleIconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIconsDictionary = bundleIconsDictionary["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? [Any],
              let lastIcon = iconFiles.last as? String,
              let iconImage = UIImage(named: lastIcon)
        else {
            return nil
        }
        return iconImage
    }()

}
