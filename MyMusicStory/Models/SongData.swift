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
    let pic: String
    let song: String
    
}

struct SongData {
    static let songList = [
        SongType(name: "Secret Love Song", artist: "Little Mix", pic: "", song: ""),
        SongType(name: "哪裡只得我共你",artist: "Dear Jane", pic: "", song: ""),
        SongType(name: "推開世界的門", artist: "楊乃文",pic: "", song: ""),
        SongType(name: "少女的祈禱", artist: "",pic: "", song: ""),
        SongType(name: "不要離我太遠", artist: "",pic: "", song: ""),
        SongType(name: "今天清晨", artist: "",pic: "", song: ""),
        SongType(name: "惡作劇", artist: "",pic: "", song: ""),
        SongType(name: "怎麼還不愛", artist: "",pic: "", song: ""),
        SongType(name: "小幸運", artist: "",pic: "", song: ""),
        SongType(name: "寫不出來", artist: "",pic: "", song: ""),
        SongType(name: "親愛的你怎麼不在身邊", artist: "",pic: "", song: ""),
        SongType(name: "經過一些秋與冬", artist: "",pic: "", song: ""),
        SongType(name: "A New Day Has Come", artist: "",pic: "", song: ""),
    ]
}

