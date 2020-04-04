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
    var playerItem: AVPlayerItem!
    var timeObserverToken: Any?

    var songIndex: Int!
    
    var isPlaying = true
    
    var timer = Timer()
    
    var currentTimeInSec: Int!
//    var startTimeInSec = 0
    var totalTimeInSec: Int!
    var remainingTimeInSec: Int!
    
    
    @IBOutlet weak var songImageView: UIImageView!
    
    @IBOutlet weak var songNameLabel: UILabel!
    
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var songProgress: UIProgressView!
    
    @IBOutlet var timeLabel: [UILabel]!
    
    // MARK: Volume Setting

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
    
    // MARK: Play Music
    @IBAction func playButtonPressed(_ sender: UIButton) {
        switch sender.tag {
            
        case 1:
            if songIndex == 0 {
                songIndex = SongData.songList.count - 1
            } else {
                songIndex -= 1
            }
            
            playMusic()
            updateInfo()
//            getCurrentSongDuration()
            addPeriodicTimeObserver()
            
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
//            getCurrentSongDuration()
            addPeriodicTimeObserver()

        default:
            print("playButton error")
 
        }
    }
    
    func playMusic() {
        guard let fileURL = Bundle.main.url(forResource: SongData.songList[songIndex].name, withExtension: "mp3") else { return }
        playerItem = AVPlayerItem(url: fileURL)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    func updateInfo() {
        let currentSong = SongData.songList[songIndex]
        songImageView.image = UIImage(named: currentSong.name)
        songNameLabel.text = currentSong.name
        artistLabel.text = currentSong.artist
    }
    
    
    // MARK: Music Progress
    
//    func getCurrentSongDuration() {
//        guard let fileURL = Bundle.main.url(forResource: SongData.songList[songIndex].name, withExtension: "mp3") else { return }
//        let playItem = AVPlayerItem(url: fileURL)
//        player.replaceCurrentItem(with: playItem)
//        let duration = playItem.asset.duration
//        let second = CMTimeGetSeconds(duration)
//        print("duration is : \(second)")
////        print("test sec : \(player.currentTime().seconds)")
//        totalTimeInSec = Int(second)
//        remainingTimeInSec = Int(second)
//        progressCount()
//    }
//
//    func progressCount() {
//        timer.invalidate()
//        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (timer) in
//            self?.updateProgressUI()
//        })
//
//    }
    
//    @objc func updateProgressUI() {
//        if remainingTimeInSec == 0 {
//            timer.invalidate()
//        } else {
//            startTimeInSec += 1
//            remainingTimeInSec -= 1
//        }
////        print(startTimeInSec, totalTimeInSec)
//        timeLabel[0].text = timeConverter(startTimeInSec)
//        timeLabel[1].text = "-\(timeConverter(remainingTimeInSec))"
//        songProgress.progress = Float(startTimeInSec) / Float(totalTimeInSec)
//    }
    
    func updateProgressUI() {
        
        if currentTimeInSec == totalTimeInSec {
            removePeriodicTimeObserver()
        } else {
            remainingTimeInSec = totalTimeInSec - currentTimeInSec
            timeLabel[0].text = timeConverter(currentTimeInSec)
            timeLabel[1].text = "-\(timeConverter(remainingTimeInSec))"
            songProgress.progress = Float(currentTimeInSec) / Float(totalTimeInSec)
        }
        
    }
    
    
    func timeConverter(_ timeInSecond: Int) -> String {
        let minute = timeInSecond / 60
        let second = timeInSecond % 60
        
        return second < 10 ? "\(minute):0\(second)" : "\(minute):\(second)"

    }
    
    func addPeriodicTimeObserver() {
        // Notify every half second
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)

        timeObserverToken = player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
            
            let duration = self?.playerItem.asset.duration
            let second = CMTimeGetSeconds(duration!)
            self!.totalTimeInSec = Int(second)
            
            let songCurrentTime = self?.player.currentTime().seconds
//            print("current time: \(songCurrentTime)")
            self!.currentTimeInSec = Int(songCurrentTime!)
            
            self!.updateProgressUI()
            
//            self!.remainingTimeInSec = self!.totalTimeInSec - self!.currentTimeInSec
//
//            self!.timeLabel[0].text = self!.timeConverter(self!.currentTimeInSec)
//            self!.timeLabel[1].text = "-\(self!.timeConverter(self!.remainingTimeInSec))"
//            self!.songProgress.progress = Float(self!.currentTimeInSec) / Float(self!.totalTimeInSec)
            
        }
    }

    func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    
    
    // MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playMusic()
        updateInfo()
//        getCurrentSongDuration()
        addPeriodicTimeObserver()

    }
        
    


}
