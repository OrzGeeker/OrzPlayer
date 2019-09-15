//
//  OrzAlertManager.swift
//  OrzPlayer
//
//  Created by joker on 2019/9/15.
//  Copyright © 2019 joker. All rights reserved.
//
import UIKit

class OrzAlertManager {
    
    static let shareInstance = OrzAlertManager()
    
    func showAlertWith(title: String? = "Oops 😏", message: String?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(action)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
}
