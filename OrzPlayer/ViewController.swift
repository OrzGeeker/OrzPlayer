//
//  ViewController.swift
//  OrzPlayer
//
//  Created by joker on 2018/11/29.
//  Copyright © 2018 joker. All rights reserved.
//

import UIKit
import OrzFMod

class ViewController: UIViewController {
  
    var player = FModCapsule()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let FModResBundle = Bundle(for: FModCapsule.self);
        player.playStream(withFilePath: FModResBundle.path(forResource: "test", ofType: "xm"))
    }
}

