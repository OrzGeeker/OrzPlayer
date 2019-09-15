//
//  OrzPlayer.swift
//  jokerHub
//
//  Created by JokerAtBaoFeng on 2018/1/3.
//  Copyright © 2018年 joker. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import OrzFMod

class OrzPlayer {
    
    let downloadProgress = PublishSubject<Float>()
    
    private var downloadRequest: DownloadRequest? = nil
    private let fmod = FModCapsule()
    private let mediaDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    
    var filePath:String?
    
    var playing: Bool {
        return fmod.isPlaying()
    }
    
    func playSound(url: String){
        
        guard let encodeURL = URL(string: url) else {
            return
        }
        
        let fileURL = self.mediaDir.appendingPathComponent(encodeURL.lastPathComponent)
        self.filePath = fileURL.path.removingPercentEncoding
        
        let downFileDestination: DownloadRequest.DownloadFileDestination = { _,_ in
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        };
        
        
        if FileManager.default.fileExists(atPath: fileURL.path.removingPercentEncoding!) {
            if let filePath = self.filePath {
                self.playSound(filePath: filePath)
            }
        }
        else {
            
            if let downloadRequest = self.downloadRequest {
                downloadRequest.cancel()
            }
            
            downloadRequest = Alamofire.download(encodeURL, to: downFileDestination)
                .downloadProgress {[weak self] (progress) in
                    print("已下载：\(progress.completedUnitCount/1024)KB")
                    print("总大小：\(progress.totalUnitCount/1024)KB")
    
                    let percent = Float(progress.completedUnitCount) / Float(progress.totalUnitCount)
                    print("\(progress.fractionCompleted)")
                    self?.downloadProgress.onNext(percent)
                }
                .responseData {[weak self] (response) in
                    if let _ = response.result.value {
                        print("download completed!")
                        
                        self?.downloadProgress.onNext(1)
                        
                        if let filePath = self?.filePath {
                            self?.playSound(filePath: filePath)
                        }
                    }

                    else if let error = response.error, error.localizedDescription != "cancelled" {
                        self?.downloadProgress.onNext(-1)
                        print(error.localizedDescription)

                    }
            }
        }
    }
    
    func playSound(filePath: String){
        fmod.playStream(withFilePath: filePath)
    }
    
    func play() {
        fmod.play()
    }
    
    func pause() {
        fmod.pause()
    }
    
    func stop() {
        fmod.stop()
    }
    
    deinit {
        fmod.close()
    }
}
