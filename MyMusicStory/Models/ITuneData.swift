//
//  ITuneData.swift
//  MyMusicStory
//
//  Created by Penny Huang on 2020/4/15.
//  Copyright © 2020 Penny Huang. All rights reserved.
//

import UIKit

struct SongResults: Codable {
    let resultCount: Int
    let results: [SongType]
}

struct SongType: Codable {
    let artistName: String
    let collectionName: String
    let trackName: String
    let previewUrl: URL
    let releaseDate: String
    let artworkUrl100: String
    let isStreamable: Bool
}

internal struct ITuneController {
    internal static let shared = ITuneController()

    // MARK: - Download Data
    func fetchITuneData(completion: @escaping ([SongType]?) -> ()) {
        let urlStr = "https://itunes.apple.com/search?term=taylorswift&media=music"
            if let url = URL(string: urlStr) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data, let iTuneData = try? JSONDecoder().decode(SongResults.self, from: data) {
                        completion(iTuneData.results)
                    } else {
                        completion(nil)
                }
            }.resume()
        }
    }
    
    func fetchImage(urlStr: String, completion: @escaping (UIImage?) -> ()) {
//        var urlStr = songs[songIndex].artworkUrl100
        let urlStr1000 = urlStr.replacingOccurrences(of: "100x100", with: "1000x1000")
        if let url = URL(string: urlStr1000) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }.resume()
        }
    }
}
