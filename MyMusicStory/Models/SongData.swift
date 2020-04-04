//
//  SongData.swift
//  MyMusicStory
//
//  Created by Penny Huang on 2020/4/2.
//  Copyright © 2020 Penny Huang. All rights reserved.
//

import Foundation

struct SongType {
    let name: String
    let artist: String
}

struct SongData {
    static let songList = [
        SongType(name: "Secret Love Song", artist: "Little Mix"),
        SongType(name: "哪裡只得我共你",artist: "Dear Jane"),
        SongType(name: "推開世界的門", artist: "楊乃文"),
        SongType(name: "少女的祈禱", artist: ""),
        SongType(name: "不要離我太遠", artist: ""),
        SongType(name: "今天清晨", artist: ""),
        SongType(name: "惡作劇", artist: ""),
        SongType(name: "怎麼還不愛", artist: ""),
        SongType(name: "勇氣", artist: ""),
        SongType(name: "小幸運", artist: ""),
        SongType(name: "寫不出來", artist: ""),
        SongType(name: "親愛的你怎麼不在身邊", artist: ""),
        SongType(name: "經過一些秋與冬", artist: ""),
        SongType(name: "成全", artist: ""),
        SongType(name: "A New Day Has Come", artist: ""),
        SongType(name: "The Last Time", artist: ""),
    ]
}

