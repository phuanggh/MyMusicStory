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
    
    var currentTimeInSec: Float!
    var totalTimeInSec: Float!
    var remainingTimeInSec: Float!
    
    
    @IBOutlet weak var songImageView: UIImageView!
    
    @IBOutlet weak var songNameLabel: UILabel!
    
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var songProgress: UIProgressView!
    
    @IBOutlet var timeLabel: [UILabel]!
    
    // MARK: - Volume Setting

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
    
    // MARK: - Play Music
    @IBAction func playButtonPressed(_ sender: UIButton) {
        switch sender.tag {
            
        case 1:
            if songIndex == 0 {
                songIndex = SongData.songList.count - 1
            } else {
                songIndex -= 1
            }
//            removePeriodicTimeObserver()
            playMusic()
//            updateInfo()
            
//            addPeriodicTimeObserver()
            
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
            
//            removePeriodicTimeObserver()
            playMusic()
//            updateInfo()

//            addPeriodicTimeObserver()

        default:
            print("playButton error")
 
        }
    }
    
    func playMusic() {
        removePeriodicTimeObserver()
        guard let fileURL = Bundle.main.url(forResource: SongData.songList[songIndex].name, withExtension: "mp3") else { return }
        playerItem = AVPlayerItem(url: fileURL)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
        updateInfo()
        addPeriodicTimeObserver()
        
    }
    
    func updateInfo() {
        let currentSong = SongData.songList[songIndex]
        songImageView.image = UIImage(named: currentSong.name)
        songNameLabel.text = currentSong.name
        artistLabel.text = currentSong.artist
    }
    
    
    // MARK: - Music Progress
    
    func addPeriodicTimeObserver() {
        // Notify every half second
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)

        timeObserverToken = player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
            let duration = self?.playerItem.asset.duration
            let second = CMTimeGetSeconds(duration!)
            self!.totalTimeInSec = Float(second)
            
            let songCurrentTime = self?.player.currentTime().seconds
            self!.currentTimeInSec = Float(songCurrentTime!)
            
            self!.updateProgressUI()
            
        }
    }

    func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    func updateProgressUI() {
        
        if currentTimeInSec == totalTimeInSec {
            removePeriodicTimeObserver()
        } else {
            remainingTimeInSec = totalTimeInSec - currentTimeInSec
            timeLabel[0].text = timeConverter(currentTimeInSec)
            timeLabel[1].text = "-\(timeConverter(remainingTimeInSec))"
            songProgress.progress = currentTimeInSec / totalTimeInSec
        }
        
    }
    
    
    func timeConverter(_ timeInSecond: Float) -> String {
        let minute = Int(timeInSecond) / 60
        let second = Int(timeInSecond) % 60
        
        return second < 10 ? "\(minute):0\(second)" : "\(minute):\(second)"

    }
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playMusic()
//        updateInfo()
//        addPeriodicTimeObserver()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { (notification) in

//            self.removePeriodicTimeObserver()
                if self.songIndex == SongData.songList.count - 1 {
                    self.songIndex = 0
                } else {
                    self.songIndex += 1
                }
//
                self.playMusic()
//                self.updateInfo()
//                self.addPeriodicTimeObserver()
            }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removePeriodicTimeObserver()
    }
        
    


}
