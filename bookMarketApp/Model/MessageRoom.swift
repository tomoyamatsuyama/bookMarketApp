//
//  MessageRoom.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/12.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import Foundation

struct PurchasedBook: Codable {
    var Book: BookInfo
    var CommentRoom: CommentRoomInfo
    var Room: MessageRoomInfo
    var CurrentUser: User
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
        var user_name: String
        var money: Int
        var image1: Image
        var image2: Image
        var image3: Image
        var flag: Int
        var buy_id: Int?
        var updated_at: String
        var created_at: String
    }
    
    struct CommentRoomInfo: Codable {
        var id: Int
        var book_id: String
        var created_at: String
        var updated_at: String
    }
    
    struct MessageRoomInfo: Codable {
        var id: Int
        var user_id: Int
        var user_2: Int
        var book_id: Int
        var created_at: String
        var updated_at: String
    }
    
    struct User: Codable {
        var id: Int
        var email: String
        var encrypted_password: String
        var user_name: String
        var created_at: String
        var updated_at: String
    }
}

struct MessageModel: Codable {
    var Room: RoomInfo
    var User: User
    var Messages: [Contents]
    var CurrentUser: User
    
    struct RoomInfo: Codable {
        var id: Int
        var user_id: Int
        var user_2: Int
        var name: String
        var image1: String
        var book_id: Int
        var updated_at: String
        var created_at: String
    }
    
    struct User: Codable {
        var id: Int
        var email: String
        var user_name: String
        var created_at: String
        var updated_at: String
    }
    
    struct CurrentUser: Codable {
        var id: Int
        var email: String
        var encrypted_password: String
        var user_name: String
        var created_at: String
        var updated_at: String
    }
    
    struct Contents: Codable {
        var id: Int
        var content: String
        var room_id: Int
        var user_id: Int
        var user_name: String
        var created_at: String
        var updated_at: String
    }
}

struct MessageData {
    var bookId: Int = 0
    var roomId: Int = 0
    var userIdLists: [Int] = []
    var userNameLists: [String] = []
    var contentsLists: [String] = []
}
