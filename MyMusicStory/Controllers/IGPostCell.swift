//
//  IGPostCell.swift
//  MyMusicStory
//
//  Created by Penny Huang on 2020/4/12.
//  Copyright © 2020 Penny Huang. All rights reserved.
//

import UIKit

class IGPostCell: UITableViewCell {

    var igData: IGData!
    
    @IBOutlet weak var proPicImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var postTimeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        proPicImageView.layer.cornerRadius = proPicImageView.frame.height / 2
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
