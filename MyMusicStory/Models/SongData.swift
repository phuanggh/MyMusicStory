//
//  SongData.swift
//  MyMusicStory
//
//  Created by Penny Huang on 2020/4/2.
//  Copyright © 2020 Penny Huang. All rights reserved.
//

import Foundation

struct Song {
    let name: String
    let artist: String
}

struct SongData {
    static let songList = [
        Song(name: "Secret Love Song", artist: "Little Mix"),
        Song(name: "哪裡只得我共你",artist: "Dear Jane"),
        Song(name: "推開世界的門", artist: "楊乃文"),
        Song(name: "少女的祈禱", artist: ""),
        Song(name: "不要離我太遠", artist: ""),
        Song(name: "今天清晨", artist: ""),
        Song(name: "惡作劇", artist: ""),
        Song(name: "怎麼還不愛", artist: ""),
        Song(name: "勇氣", artist: ""),
        Song(name: "小幸運", artist: ""),
        Song(name: "寫不出來", artist: ""),
        Song(name: "親愛的你怎麼不在身邊", artist: ""),
        Song(name: "經過一些秋與冬", artist: ""),
        Song(name: "成全", artist: ""),
        Song(name: "A New Day Has Come", artist: ""),
        Song(name: "The Last Time", artist: ""),
    ]
}

