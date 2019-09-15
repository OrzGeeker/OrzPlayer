//
//  OrzAlertManager+music.swift
//  OrzPlayer
//
//  Created by joker on 2019/9/15.
//  Copyright © 2019 joker. All rights reserved.
//

enum OraAlertMessageType {
    case downloadMusicFailed
}

extension OrzAlertManager {
    class func show(_ type: OraAlertMessageType) {
        
        var alertMsg: String
        
        switch type {
        case .downloadMusicFailed:
            alertMsg = "下载音乐文件出错"
        }
        
        OrzAlertManager.shareInstance.showAlertWith(message: alertMsg)
    }
}
