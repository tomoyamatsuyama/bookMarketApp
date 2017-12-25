//
//  CommentRoom.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/12.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import Foundation

struct CommentInfo: Codable {
    var Commentroom: RoomInfo
    var Book: BookInfo
    var Comments: [CommentsRoomContents]
    var CurrentUser: User
    struct User: Codable {
        var id: Int
        var email: String
        var encrypted_password: String
        var user_name: String
        var created_at: String
        var updated_at: String
    }
    
    struct RoomInfo: Codable {
        var id: Int
        var book_id: String
        var created_at: String
        var updated_at: String
    }
    struct BookInfo: Codable {
        struct Image: Codable {
            var url: String?
        }
        var id: Int
        var name: String
        var isbn: String
        var author: String
        var lesson: String
        var user_id: Int
        var money: Int
        var image1: Image
        var image2: Image
        var image3: Image
        var flag: Int
        var buy_id: Int?
        var updated_at: String
        var created_at: String
    }
    
    struct CommentsRoomContents: Codable {
        var id: Int
        var commentroom_id: Int
        var user_id: Int
        var user_name: String
        var comment: String
        var created_at: String
        var updated_at: String
    }
}

struct CommentData {
    var id: [Int] = []
    var userId: [Int] = []
    var userName: [String] = []
    var content: [String] = []
    var currentUserId: Int = 0
    var roomId: Int = 0
}
