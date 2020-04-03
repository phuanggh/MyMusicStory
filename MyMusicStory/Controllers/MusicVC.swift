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
    
    var player = AVPlayer()

    var songIndex: Int!
    
    var isPlaying = true
    
    var timer = Timer()
    
    var startTimeInSec = 0
    var totalTimeInSec: Int!
    var remainingTimeInSec: Int!
    
    
    @IBOutlet weak var songImageView: UIImageView!
    
    @IBOutlet weak var songNameLabel: UILabel!
    
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var songProgress: UIProgressView!
    
    @IBOutlet var timeLabel: [UILabel]!
    
    
    

    @IBAction func volumeButtonPressed(_ sender: UIButton) {
        if sender.tag == 11 {
            player.isMuted = true
        } else {
            player.isMuted = false
        }
    }
    
    @IBAction func volumeSliderChanged(_ sender: UISlider) {
        let sliderValue = sender.value
        player.volume = sliderValue
    }
    
    @IBAction func playButton(_ sender: UIButton) {
        switch sender.tag {
            
        case 1:
            if songIndex == 0 {
                songIndex = SongData.songList.count - 1
            } else {
                songIndex -= 1
            }
            
            playMusic()
            updateInfo()
            
        case 2:
            isPlaying ? player.pause() : player.play()
            sender.setImage(UIImage(systemName: isPlaying ? "play.fill" :  "pause.fill"), for: .normal)
            isPlaying = !isPlaying

        case 3:
            
            if songIndex == SongData.songList.count - 1 {
                songIndex = 0
            } else {
                songIndex += 1
            }

            playMusic()
            updateInfo()

        default:
            print("playButton error")
 
        }
    }
    
    func playMusic() {
        guard let fileURL = Bundle.main.url(forResource: SongData.songList[songIndex].name, withExtension: "mp3") else { return }
        let playItem = AVPlayerItem(url: fileURL)
        player.replaceCurrentItem(with: playItem)
        player.play()
    }
    
    func updateInfo() {
        let currentSong = SongData.songList[songIndex]
        songImageView.image = UIImage(named: currentSong.name)
        songNameLabel.text = currentSong.name
        artistLabel.text = currentSong.artist
    }
    
    func getCurrentSongDuration() {
        guard let fileURL = Bundle.main.url(forResource: SongData.songList[songIndex].name, withExtension: "mp3") else { return }
        let playItem = AVPlayerItem(url: fileURL)
        player.replaceCurrentItem(with: playItem)
        let duration = playItem.asset.duration
        let second = CMTimeGetSeconds(duration)
        totalTimeInSec = Int(second)
        remainingTimeInSec = Int(second)
        progressCount()
    }
    
    func progressCount() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateProgressUI), userInfo: nil, repeats: true)

    }
    
    @objc func updateProgressUI() {
        if remainingTimeInSec == 0 {
            timer.invalidate()
        } else {
            startTimeInSec += 1
            remainingTimeInSec -= 1
        }
//        print(startTimeInSec, totalTimeInSec)
        timeLabel[0].text = timeConverter(startTimeInSec)
        timeLabel[1].text = "-\(timeConverter(remainingTimeInSec))"
        songProgress.progress = Float(startTimeInSec) / Float(totalTimeInSec)
    }
    
    
    func timeConverter(_ timeInSecond: Int) -> String {
        let minute = timeInSecond / 60
        let second = timeInSecond % 60
        
        return second < 10 ? "\(minute):0\(second)" : "\(minute):\(second)"

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playMusic()
        updateInfo()
        getCurrentSongDuration()

    }
        
    


}
