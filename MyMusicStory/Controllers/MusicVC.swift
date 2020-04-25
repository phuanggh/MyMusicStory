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
    
    var songs = [SongType]()
    
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
    
    @IBOutlet var playButton: [UIButton]!
    
    
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
                songIndex = songs.count - 1
            } else {
                songIndex -= 1
            }
            
            playButton[1].setImage(UIImage(systemName: "pause.fill"), for: .normal)
            playMusic()
            
        case 2:
            isPlaying ? player.pause() : player.play()
            sender.setImage(UIImage(systemName: isPlaying ? "play.fill" :  "pause.fill"), for: .normal)
            isPlaying = !isPlaying

        case 3:
            if songIndex == songs.count - 1 {
                songIndex = 0
            } else {
                songIndex += 1
            }
            
            playButton[1].setImage(UIImage(systemName: "pause.fill"), for: .normal)
            playMusic()

        default:
            print("playButton error")
 
        }
    }
    
    func playMusic() {
        removePeriodicTimeObserver()
        
        // Plau music
        let songURL = songs[songIndex].previewUrl
        playerItem = AVPlayerItem(url: songURL)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
        // Update song info
        DispatchQueue.main.async {
            self.updateInfo()
        }
        
        // Update song image
        ITuneController.shared.fetchImage(urlStr: songs[songIndex].artworkUrl100) { (image) in
            DispatchQueue.main.async {
                self.songImageView.image = image
            }
        }
        
        // Time observer
        addPeriodicTimeObserver()
        
    }
    
    func updateInfo() {
        let currentSong = songs[songIndex]
        songNameLabel.text = currentSong.trackName
        artistLabel.text = currentSong.artistName
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
        
        // UI design
        let colour1 = #colorLiteral(red: 0.924761951, green: 0.2762447596, blue: 0.4667485952, alpha: 1).cgColor
        let colour2 = #colorLiteral(red: 0.3803921569, green: 0.2901960784, blue: 0.8274509804, alpha: 1).cgColor
        let colour3 = #colorLiteral(red: 0.07058823529, green: 0.1058823529, blue: 0.4549019608, alpha: 1).cgColor
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [colour1,colour2, colour3]
        gradient.locations = [0, 0.5,1]

        view.layer.insertSublayer(gradient, at: 0)
        
        // Download data
        ITuneController.shared.fetchITuneData { (songs) in
            self.songs = songs!
            self.playMusic()
        }
        
        // AV Player
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { [weak self] (notification) in

            if self?.songIndex == (self?.songs.count)! - 1 {
                self?.songIndex = 0
            } else {
                self?.songIndex += 1
            }
        
            self?.playMusic()

        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removePeriodicTimeObserver()
    }

}
