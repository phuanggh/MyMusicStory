//
//  ViewController.swift
//  MyMusicStory
//
//  Created by Penny Huang on 2020/3/29.
//  Copyright © 2020 Penny Huang. All rights reserved.
//

import UIKit

class PlaylistVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var songIndex: Int?
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet var musicButton: [UIButton]!
    
    
    // MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SongData.songList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongCell
        cell.numberLabel.text = String( indexPath.row + 1)
        cell.songNameLabel.text = SongData.songList[indexPath.row].name
        
        return cell
    }
    
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        songIndex = tableView.indexPathForSelectedRow?.row
        performSegue(withIdentifier: "goToMusic", sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    // MARK: - Actions
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        if sender.tag == 1 {
            songIndex = 0
        } else {
            songIndex = Int.random(in: 0 ... SongData.songList.count-1)
        }
        performSegue(withIdentifier: "goToMusic", sender: self)
    }
    

    
    @IBSegueAction func segueAction(_ coder: NSCoder) -> MusicVC? {
    
        let controller = MusicVC(coder: coder)
        controller?.songIndex = songIndex
        
        return controller
    }
    
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        musicButton[0].layer.cornerRadius = musicButton[0].frame.height / 4
        musicButton[1].layer.cornerRadius = musicButton[1].frame.height / 4
        
        let colour1 = #colorLiteral(red: 0.3803921569, green: 0.2901960784, blue: 0.8274509804, alpha: 1).cgColor
        let colour2 = #colorLiteral(red: 0.924761951, green: 0.2762447596, blue: 0.4667485952, alpha: 1).cgColor
        let gradient = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = [colour1,colour2]
        gradient.locations = [0, 1]

        view.layer.insertSublayer(gradient, at: 0)
        
    }


}

