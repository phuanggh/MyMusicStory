//
//  ITuneData.swift
//  MyMusicStory
//
//  Created by Penny Huang on 2020/4/15.
//  Copyright © 2020 Penny Huang. All rights reserved.
//

import Foundation

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
