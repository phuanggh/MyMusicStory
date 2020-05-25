//
//  IGCollectionView.swift
//  MyMusicStory
//
//  Created by Penny Huang on 2020/5/23.
//  Copyright © 2020 Penny Huang. All rights reserved.
//

import UIKit

class IGPicVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {


    struct PropertyKeys {
        static let header = "header"
        static let imageCell = "igImageCell"
    }
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    
    
    // MARK: - Collection View
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PropertyKeys.imageCell, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
//        let reusableView = UICollectionReusableView()
        let reusableView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PropertyKeys.header, for: indexPath)
        
        return reusableView
    }
    
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewLayout()

    }
    

    func setCollectionViewLayout() {

        let flowLayout = UICollectionViewFlowLayout()
        
        // Header
        flowLayout.headerReferenceSize = CGSize(width: view.frame.width, height: 200)
        collectionViewOutlet.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PropertyKeys.header)
    
        // Cell
        let cellPerRow: CGFloat = 4
        let cellSpacing: CGFloat = 10
        let lineSpacing: CGFloat = 10
        let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        
        let widthPerItem = floor((view.frame.width - (sectionInsets.left + sectionInsets.right) - cellSpacing * (cellPerRow - 1) ) / 4)
        flowLayout.itemSize = CGSize(width: widthPerItem, height: widthPerItem)
        
        flowLayout.estimatedItemSize = .zero
        flowLayout.minimumInteritemSpacing = cellSpacing
        flowLayout.minimumLineSpacing = lineSpacing
        flowLayout.sectionInset = sectionInsets
        
        collectionViewOutlet.collectionViewLayout = flowLayout
    
    }
    

}
