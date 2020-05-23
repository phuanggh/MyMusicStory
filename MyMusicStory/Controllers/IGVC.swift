//
//  IGVCViewController.swift
//  MyMusicStory
//
//  Created by Penny Huang on 2020/4/11.
//  Copyright © 2020 Penny Huang. All rights reserved.
//
import UIKit

class IGVC: UIViewController {
    
    
    var igData: IGData!
    var igPosts = [IGData.Graphql.User.Edge_owner_to_timeline_media.Edges]()
    
    @IBOutlet weak var proPicImageView: UIImageView!
    @IBOutlet weak var NumOfPostLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var biographyTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    
    func updateProfileUI() {

        followerLabel.text = followerNumConverter(igData.graphql.user.edge_followed_by.count)
        fullNameLabel.text = " \(igData.graphql.user.full_name)"
        biographyTextView.text = igData.graphql.user.biography
        NumOfPostLabel.text = String( igData.graphql.user.edge_owner_to_timeline_media.count)
        
        IGDataController.shared.updateImage(url: igData.graphql.user.profile_pic_url_hd) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.proPicImageView.image = image
                }
            case .failure(let networkError):
                switch networkError {
                case .invalidUrl, .invalidData, .invalidResponse:
                    print(networkError)
                case .requestFailed(let error):
                    print(networkError, error)
                default:
                    print("Unidentified Error")
                }
            
            }

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
    

//    func testGetSongs() {
//        guard let data = NSDataAsset(name: "ituneData")?.data else {
//           print("data not exist")
//           return
//        }
//        do {
//           let decoder = JSONDecoder()
//           let result = try decoder.decode(SongResults.self, from: data)
//           print(result)
//        } catch  {
//           print(error)
//        }
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        testGetSongs()
        IGDataController.shared.fetchIGData { result in
            switch result {
            case .success(let igData):
                self.igData = igData
                self.igPosts = igData.graphql.user.edge_owner_to_timeline_media.edges
                DispatchQueue.main.async {
                    self.updateProfileUI()
                    self.tableView.reloadData()
                }
            case .failure(let networkError):
                switch networkError {
                case .requestFailed(let error):
                    print(networkError, error)
                case .invalidUrl, .invalidData, .invalidResponse, .decodingError:
                    print(networkError)
                }
            }
        }
        
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
extension IGVC: UITableViewDelegate, UITableViewDataSource {
    
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

        // Post timestamp
        let timestamp = post.node.taken_at_timestamp
        let postTime = Date(timeIntervalSince1970: timestamp!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
//        dateFormatter.dateFormat = "yyyy MMMM dd"
        
        let dateString = dateFormatter.string(from: postTime)
//        print("date string: \(dateString)")
        
        cell.postTimeLabel.text = " \(dateString)"
        
        // Post Image
        if let postImageURL = post.node.thumbnail_src {
            IGDataController.shared.updateImage(url: postImageURL) { (result) in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        cell.postImageView.image = image
                    }
                case .failure(let networkError):
                    switch networkError {
                    case .requestFailed(let error):
                        print(networkError, error)
                    case .invalidData, .invalidResponse:
                        print(networkError)
                    default:
                        print("Unidentified Error")
                    }
                }
            }
        }
        
        // Pro pic image
        let proPicURL = igData.graphql.user.profile_pic_url_hd
        IGDataController.shared.updateImage(url: proPicURL) { (result) in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    cell.proPicImageView.image = image
                }
            case .failure(let networkError):
                switch networkError {
                case .requestFailed(let error):
                    print(networkError, error)
                case .invalidData, .invalidResponse:
                    print(networkError)
                default:
                    print("Unidentified Error")
                }
            }
        }
        
        return cell
    }
    
}
