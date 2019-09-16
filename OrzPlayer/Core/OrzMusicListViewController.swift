//
//  OrzMusicListViewController.swift
//  jokerHub
//
//  Created by joker on 2018/1/3.
//  Copyright © 2018年 joker. All rights reserved.
//

import UIKit
import RxSwift

class OrzMusicListViewController: UITableViewController {
    
    let bag = DisposeBag()
    
    let fmodPlayer = OrzPlayer()
    var curPlayItemNavStack: Array<Directory>?
    var curPlayItem: File?
    var navStack = Array<Directory>()
    private var dataSourceStore: Array<Any>?
    var dataSource: Array<Any>? {
        get {
            return self.dataSourceStore
        }
        
        set {
            self.dataSourceStore = newValue?.filter({ (node) -> Bool in
                if node is File {
                    return (node as! File).playable
                }
                return true
            })
        }
    }
    var report: Report?
    
    @IBOutlet weak var musicListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.beginRefreshing()
        
        DispatchQueue.global().async {

            if let music = Music.readCacheMusicJSON() {
                self.loadMusic(music: music)
            } else {
                self.requestMusicList()
            }
        }
    
        fmodPlayer.downloadProgress
            .distinctUntilChanged()
            .subscribe(onNext: { (progress) in
            if progress >= 0 && progress < 1 {

            }
            else if progress >= 1 {

            }
            else if progress == -1 {
                OrzAlertManager.show(.downloadMusicFailed)
            }
        })
        .disposed(by: bag)
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        requestMusicList()
    }
    
    func requestMusicList() {
        
        DispatchQueue.main.async {
            if let refreshing = self.refreshControl?.isRefreshing, refreshing == false {
                self.refreshControl?.beginRefreshing()
            }
        }

        Music.requestMusicList { [weak self] (music) in
            self?.loadMusic(music: music)
        }
    }
    func loadMusic(music: Music?) {
        
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
            
            if let music = music {
                
                self.report = music.report
                
                self.navStack.removeAll()
                if let root = music.root {
                    self.dataSource = root.contents
                    self.navStack.append(root)
                }
                self.musicListTableView.reloadData()
            }
        }
    }
        
    func playStreamRemote(resURL: String?) {
        if let urlStr = resURL {
            fmodPlayer.stop()
            fmodPlayer.playSound(url: urlStr)
        }
    }
    
    func filePath() -> String {
        return self.navStack.reduce("") { (result, directory) -> String in
            if let dirName = directory.name, dirName != "." {
                return result + dirName + "/"
            }
            return result
        }
    }
    
    @IBAction func play(_ sender: Any) {
        
        if let curPlayItemNavStack = self.curPlayItemNavStack,
            fmodPlayer.playing {
            self.navStack = curPlayItemNavStack
            self.dataSource = self.navStack.last?.contents
            self.musicListTableView.reloadData()
        }
        fmodPlayer.play()
    }
    @IBAction func backward(_ sender: Any) {
        
        if self.navStack.count > 1 {
            self.navStack.removeLast()
            self.dataSource = self.navStack.last?.contents
            self.musicListTableView.reloadData()
            
        }
    }
    
    @IBAction func pause(_ sender: UIBarButtonItem) {
        if fmodPlayer.playing {
            fmodPlayer.pause()
        }
    }
    //MARK: UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        var title = filePath()
        
        if let report = self.report, title.isEmpty {
            
            let totalDirs = report.directories ?? 0
            let totalFiles = report.files ?? 0
            title = "\(totalDirs) directorys, \(totalFiles) files."
        }
        
        return title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let node = dataSource?[indexPath.row] {
            if node is File {
                let fileCell = tableView.dequeueReusableCell(withIdentifier: "fileCell", for: indexPath)
                
                let file = node as! File
                if let curPlayItem = self.curPlayItem, file == curPlayItem {
                    fileCell.backgroundColor = .gray
                } else {
                    fileCell.backgroundColor = .white
                }
                fileCell.textLabel?.text = file.name
                fileCell.accessoryType = .none
                fileCell.isUserInteractionEnabled = file.playable
                fileCell.textLabel?.textColor = .black
                return fileCell
            }
            else if node is Directory {
                let dirCell = tableView.dequeueReusableCell(withIdentifier: "dirCell", for: indexPath)
                
                dirCell.textLabel?.text = (node as! Directory).name
                if let childCount = (node as! Directory).contents?.count, childCount > 0 {
                    dirCell.accessoryType = .disclosureIndicator
                } else {
                    dirCell.accessoryType = .none
                }
                
                return dirCell
            }
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
    //MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
        if let node = dataSource?[indexPath.row] {
            
            if node is File {
                if let fileName = (node as! File).name {
                    let fileFullPath = filePath() + fileName;
                    let fileURL = try! OrzMusicRouter.GetMusic(filePath: fileFullPath).asURLRequest().url?.absoluteString
                    self.curPlayItemNavStack = self.navStack
                    self.curPlayItem = node as? File
                    playStreamRemote(resURL: fileURL)
                }
                
            }
            else if node is Directory {
                let dir = node as! Directory
                self.dataSource = dir.contents
                self.navStack.append(dir)
                self.musicListTableView.reloadData()
            }
        }
    }
}
