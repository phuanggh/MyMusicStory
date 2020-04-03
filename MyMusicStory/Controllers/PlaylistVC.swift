//
//  ViewController.swift
//  MyMusicStory
//
//  Created by Penny Huang on 2020/3/29.
//  Copyright © 2020 Penny Huang. All rights reserved.
//

import UIKit

class PlaylistVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableview: UITableView!
    
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
        performSegue(withIdentifier: "goToMusic", sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    

    
    @IBSegueAction func segueAction(_ coder: NSCoder) -> MusicVC? {
    
        let controller = MusicVC(coder: coder)
        controller?.songIndex = tableview.indexPathForSelectedRow?.row
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}

