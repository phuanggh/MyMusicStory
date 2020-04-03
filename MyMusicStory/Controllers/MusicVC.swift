//
//  MusicVC.swift
//  MyMusicStory
//
//  Created by Penny Huang on 2020/4/2.
//  Copyright © 2020 Penny Huang. All rights reserved.
//

import UIKit
import AVFoundation

class MusicVC: UIViewController {

    var songIndex: Int!
    
    @IBOutlet weak var songImageView: UIImageView!
    
    @IBOutlet weak var songNameLabel: UILabel!
    
    @IBOutlet weak var artistLabel: UILabel!
    
    
    
    @IBAction func playButton(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        songNameLabel.text = SongData.songList[songIndex].name
        
    }


}
