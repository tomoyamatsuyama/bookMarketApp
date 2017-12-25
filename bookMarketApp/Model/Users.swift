//
//  SignIn.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/10.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import Foundation

struct Profile: Codable {
    var User: UserInfo
    var Books: [Books]
    struct UserInfo: Codable {
        var id: Int
        var email: String
        var user_name: String
        var created_at: String
        var updated_at: String
    }
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
        var created_at: String
        var updated_at: String
    }
}

struct ProfileData {
    var userId: Int = 0
    var userName: String = ""
    var userEmail: String = ""
    var idLists: [Int] = []
    var authorLists:[String] = []
    var lessonLists: [String] = []
    var moneyLists: [Int] = []
    var nameLists: [String] = []
    var userIdLists: [Int] = []
    var imageLists: [String : Array<String?>] = [:]
    var commentRoomsId: [Int] = []
}

struct RequestError {
    enum code: Int {
        case info
        case success
        case redirection
        case cliantError
        case serverError
    }
}

struct Info {
    enum User: String {
        case id
        case name
        case email
        case auth
    }
}

