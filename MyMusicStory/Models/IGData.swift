//
//  IGData.swift
//  MyMusicStory
//
//  Created by Penny Huang on 2020/4/11.
//  Copyright © 2020 Penny Huang. All rights reserved.
//
//   let igData = try? newJSONDecoder().decode(IGData.self, from: jsonData)

import Foundation

struct IGData: Codable {
    let graphql: Graphql
    
    struct Graphql: Codable {
        let user: User
        
        struct User: Codable {

            // Following and follower
            let edge_followed_by: Count // number of followers
            let edge_follow: Count // number of following accounts

            // User info
            let username: String
            let full_name: String
            let profile_pic_url_hd: URL
            let biography: String

            // Post
            let edge_owner_to_timeline_media: Edge_owner_to_timeline_media
            struct Edge_owner_to_timeline_media: Codable {
                let count: Int // total number of posts

//                // used to request more posts
//                let page_info: Page_info
//                struct Page_info: Codable {
//                    let end_cursor: String
//                }

                // Latest 12 posts
                let edges: [Edges]
                struct Edges: Codable {
                    let node: Node
                    struct Node: Codable {
                        let shortcode: String? // individual post hashcode
                        let display_url: URL? // full picture
                        let is_video: Bool? // media type
                        let edge_liked_by: Count? // number of likes
                        let taken_at_timestamp: Double?
                        let edge_media_to_caption: Edge_media_to_caption?
                        struct Edge_media_to_caption: Codable {
                            let edges: [Edges]
                        }
//                         child level of edge_media_to_caption
                        let text: String? // picture source and text

                        let thumbnail_src: URL? // thumbnail 640 * 640
                    }
                }
            }
            
            struct Count: Codable{
                let count: Int
            }

        }
        
        
    }
    
}
