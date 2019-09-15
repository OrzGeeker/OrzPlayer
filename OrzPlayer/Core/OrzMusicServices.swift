//
//  OrzMusicServices.swift
//  OrzPlayer
//
//  Created by joker on 2019/9/15.
//  Copyright © 2019 joker. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum OrzMusicRouter: URLRequestConvertible {
    
    static let jokerhub = "http://106.13.184.237:8080" // "https://jokerhub.cn"
    
    static let musicPath = "/KeygenMusic/"
    
    static let musicListJsonFile = "music.json"

    case GetMusic(filePath: String)
    
    func asURLRequest() throws -> URLRequest {
        
        var method: HTTPMethod {
            
            switch self {
            case .GetMusic:
                return .get
            }
        }
        
        let result: (path: String, parameters:[String:Any]?) = {
            
            switch self {
            case .GetMusic(let filePath):
                return ("\(OrzMusicRouter.musicPath)\(filePath)",nil)
            }
        }()
        
        if let url = URL(string: OrzMusicRouter.jokerhub) {
        
            let urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
            
            var encodedRequest = try JSONEncoding.default.encode(urlRequest, with: result.parameters)
            
            encodedRequest.httpMethod = method.rawValue
            
            return encodedRequest
        }
        else {
            throw URLError(.badURL)
        }
    }
}

class OrzMusicServices {
    
    static let shareInstance = OrzMusicServices()
    
    func GetMusicList(completionHandler:@escaping (Result<String>) -> Void)
    {
        Alamofire.request(OrzMusicRouter.GetMusic(filePath: OrzMusicRouter.musicListJsonFile)).responseString { (response) in
            completionHandler(response.result)
        }
    }
    
    func tlsServerAllow()
    {
        let manager = SessionManager.default
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            return (URLSession.AuthChallengeDisposition.useCredential,
                    URLCredential(trust: challenge.protectionSpace.serverTrust!))
        }
    }
}
