//
//  IGCollectionView.swift
//  MyMusicStory
//
//  Created by Penny Huang on 2020/5/23.
//  Copyright © 2020 Penny Huang. All rights reserved.
//

import UIKit

class IGPicVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var igData: IGData!
    var igPosts = [IGData.Graphql.User.Edge_owner_to_timeline_media.Edges]()
    


    struct PropertyKeys {
        static let header = "headerView"
        static let imageCell = "igImageCell"
        static let toIGpostVC = "igPicToPostSegue"
    }
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    
    
    // MARK: - Collection View
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return igPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PropertyKeys.imageCell, for: indexPath) as! IGPicCell
        if let postImageURL = igPosts[indexPath.row].node.thumbnail_src {
            IGDataController.shared.updateImage(url: postImageURL) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        cell.igPicImageView.image = image
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
//            cell.igPicImageView = igPosts[indexPath.row].node.
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let reusableView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PropertyKeys.header, for: indexPath) as! IGPicHeaderReusableView
        reusableView.proPicImageView.layer.cornerRadius = reusableView.proPicImageView.frame.height / 2

        
        if igData != nil {
            reusableView.followerLabel.text = followerNumConverter(igData.graphql.user.edge_followed_by.count)
            reusableView.fullNameLabel.text = " \(igData.graphql.user.full_name)"
            reusableView.biographyTextView.text = igData.graphql.user.biography
            reusableView.NumOfPostLabel.text = String( igData.graphql.user.edge_owner_to_timeline_media.count)
        
            IGDataController.shared.updateImage(url: (igData?.graphql.user.profile_pic_url_hd)!) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        reusableView.proPicImageView.image = image
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
        
        return reusableView
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//
//        let indexPath = IndexPath(row: 0, section: section)
//        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
//
//        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height))
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: PropertyKeys.toIGpostVC, sender: indexPath)
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
    
    // MARK: - Download Data and Images
    func getIGData() {
        IGDataController.shared.fetchIGData { result in
            switch result {
            case .success(let igData):
                self.igData = igData
                self.igPosts = igData.graphql.user.edge_owner_to_timeline_media.edges
                
                DispatchQueue.main.async {
//                    self.updateProfileUI()
                    self.collectionViewOutlet.reloadData()
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
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sender = sender as! IndexPath
        let destinationVC = segue.destination as! IGPostVC
        destinationVC.indexPath = sender
        destinationVC.igData = igData
        destinationVC.igPosts = igPosts
    }
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewLayout()
        setBackground()
        getIGData()
//        IGDataController.shared.testGetData { (igdata) in
//
//        }

    }
    
    func setBackground() {
        
        let image = UIImage()

        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        self.navigationController?.navigationBar.shadowImage = image
        
        let colour1 = #colorLiteral(red: 0.3803921569, green: 0.2901960784, blue: 0.8274509804, alpha: 1).cgColor
        let colour2 = #colorLiteral(red: 0.924761951, green: 0.2762447596, blue: 0.4667485952, alpha: 1).cgColor
        let gradient = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = [colour1,colour2]
        gradient.locations = [0, 1]

        view.layer.insertSublayer(gradient, at: 0)
    }
    

    func setCollectionViewLayout() {

        let flowLayout = UICollectionViewFlowLayout()
        
        // Header
        flowLayout.headerReferenceSize = CGSize(width: view.frame.width, height: 160)
//        collectionViewOutlet.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PropertyKeys.header)
    
        // Cell
        let cellPerRow: CGFloat = 3
        let cellSpacing: CGFloat = 0
        let lineSpacing: CGFloat = 0
        let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        let widthPerItem = floor((view.frame.width - (sectionInsets.left + sectionInsets.right) - cellSpacing * (cellPerRow - 1) ) / cellPerRow)
        flowLayout.itemSize = CGSize(width: widthPerItem, height: widthPerItem)
        
        flowLayout.estimatedItemSize = .zero
        flowLayout.minimumInteritemSpacing = cellSpacing
        flowLayout.minimumLineSpacing = lineSpacing
        flowLayout.sectionInset = sectionInsets
        
        collectionViewOutlet.collectionViewLayout = flowLayout
    
    }
    

}
