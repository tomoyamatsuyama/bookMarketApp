//
//  Book.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/10.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import Foundation

struct BooksAll: Codable {
    var Books: [Books]
    var CurrentUser: User
    struct Books: Codable {
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
        var user_name: String
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

struct BooksData {
    var idLists: [Int] = []
    var authorLists:[String] = []
    var lessonLists: [String] = []
    var moneyLists: [Int] = []
    var nameLists: [String] = []
    var userIdLists: [Int] = []
    var userNameLists: [String] = []
    var imageLists: [String : Array<String?>] = [:]
    var commentRoomsId: [Int] = []
}

struct BookDetail: Codable {
    var Book: BookInfo
    var CommentRoom: CommentRoomInfo
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
}

struct BookDetailData {
    var id: Int = 0
    var name: String = ""
    var author: String = ""
    var lesson: String = ""
    var userId: Int = 0
    var userName: String = ""
    var money: Int = 0
    var imageLists: Array<String?> = []
    var flag: Int = 0
    var buyId: Int? = nil
    var commentRoomId: Int = 0
}

struct Trading: Codable {
    var Room: [Books]
    var CurrentUser: User
    struct Books: Codable {
        var id: Int
        var user_id: Int
        var user_2: Int
        var name: String
        var image1: String
        var book_id: Int
        var created_at: String
        var updated_at: String
        var author: String
        var lesson: String
        var money: Int
        var buy_id: Int
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

struct TradingData {
    var roomIdLists: [Int] = []
    var userFirstIdLists: [Int] = []
    var userSecondIdLists: [Int] = []
    var bookNameLists: [String] = []
    var imageLists: [String] = []
    var bookIdLists: [Int] = []
    var currentUserId: Int = 0
    var authorLists: [String] = []
    var lessonLists: [String] = []
    var moneyLists: [Int] = []
    var buyIdLists: [Int] = []
}

