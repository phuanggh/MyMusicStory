//
//  IGVCViewController.swift
//  MyMusicStory
//
//  Created by Penny Huang on 2020/4/11.
//  Copyright © 2020 Penny Huang. All rights reserved.
//

import UIKit

class IGVCViewController: UIViewController {
    
    
    var igData: IGData!
    var igPosts = [IGData.Graphql.User.Edge_owner_to_timeline_media.Edges]()
    
    
    @IBOutlet weak var proPicImageView: UIImageView!
    @IBOutlet weak var NumOfPostLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var biographyTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    func fetchIGData() {
        let urlStr = "https://www.instagram.com/taylorswift/?__a=1"
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let data = data, let igData = try? JSONDecoder().decode(IGData.self, from: data) {
                    
                    self.igData = igData
                    self.igPosts = igData.graphql.user.edge_owner_to_timeline_media.edges
                    
                    DispatchQueue.main.async {
                        self.updateUI()
                        self.tableView.reloadData()
                    }
                    
                }
                
            }.resume()
        }
        
    }
    
    
    func updateUI() {

        followerLabel.text = followerNumConverter(igData.graphql.user.edge_followed_by.count)
//            String(igData.graphql.user.edge_followed_by.count)
        fullNameLabel.text = " \(igData.graphql.user.full_name)"
        biographyTextView.text = igData.graphql.user.biography
        NumOfPostLabel.text = String( igData.graphql.user.edge_owner_to_timeline_media.count)
        
        do {
            let imageData = try Data(contentsOf: igData.graphql.user.profile_pic_url_hd)
            proPicImageView.image = UIImage(data: imageData)
        } catch {
            print("imageData Error")
        }
        
    }
    
    func followerNumConverter(_ num: Int) -> String{
        if num > 1000000 {
            return "\(num / 1000000) M"
        } else if num > 1000 {
            return "\(num / 1000) K"
        } else {
            return String(num)
        }
    }
    

    func testIGData() {
        guard let data = NSDataAsset(name: "igData")?.data else {
           print("data not exist")
           return
        }
        do {
           let decoder = JSONDecoder()
           let result = try decoder.decode(IGData.self, from: data)
           print(result)
        } catch  {
           print(error)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        testIGData()
        fetchIGData()
        
        proPicImageView.layer.cornerRadius = proPicImageView.frame.height / 2
        
        let colour1 = #colorLiteral(red: 0.3803921569, green: 0.2901960784, blue: 0.8274509804, alpha: 1).cgColor
        let colour2 = #colorLiteral(red: 0.924761951, green: 0.2762447596, blue: 0.4667485952, alpha: 1).cgColor
        let gradient = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = [colour1,colour2]
        gradient.locations = [0, 1]

        view.layer.insertSublayer(gradient, at: 0)

    }
    

}


// MARK: - TableView

extension IGVCViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return igPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "igPostCell", for: indexPath) as! IGPostCell
        
        let post = igPosts[indexPath.row]
        
        // Username
        cell.userNameLabel.text = igData.graphql.user.username

        // Post likes
        let likes = post.node.edge_liked_by?.count
        cell.likeLabel.text = " \(likes!) likes"
        
        // Post text
        cell.postText.text = post.node.edge_media_to_caption?.edges[0].node.text

        // Timestamp
        let timestamp = post.node.taken_at_timestamp
        let postTime = Date(timeIntervalSince1970: timestamp!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MMMM dd"
        let dateString = dateFormatter.string(from: postTime)

        cell.postTimeLabel.text = " \(dateString)"
        
        // Post Image
        let postImageURL = post.node.thumbnail_src
        URLSession.shared.dataTask(with: postImageURL!) { (data, response, error) in
            if let data = data, let postImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    cell.postImageView.image = postImage
                }
            } else {
                print("postImageURL goes wrong")
            }
        }.resume()
        
        // Pro pic image
        let proPicURL = igData.graphql.user.profile_pic_url_hd
        URLSession.shared.dataTask(with: proPicURL) {
            (data, response, error) in
            if let data = data, let proPicImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    cell.proPicImageView.image = proPicImage
                }
            }
        }.resume()
        
        
        return cell
    }
    
}
