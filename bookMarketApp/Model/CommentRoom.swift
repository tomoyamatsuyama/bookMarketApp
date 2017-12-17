//
//  CommentRoom.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/12.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//


import UIKit
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

class CommentRoom{
    static func getCommentRoom(commentRoomId: Int) -> CommentData {
        var commentData = CommentData()
        let url = Api.host + Api.Comments.Comment.getCommentRoom(commentRoomId: commentRoomId).path()
        let request = Api.getRequet(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let objects: CommentInfo = try JSONDecoder().decode(CommentInfo.self, from: data)
                objects.Comments.forEach { object in
                    commentData.userId.append(object.user_id)
                    commentData.userName.append(object.user_name)
                    commentData.content.append(object.comment)
                }
                commentData.currentUserId = objects.CurrentUser.id
                commentData.roomId = commentRoomId
            } catch let e {
                print(e)
            }
        }
        task.resume()
        Thread.sleep(forTimeInterval: 0.2)
        return commentData
    }
    
    static func postComment(_ commentId: String, _ comment: String, _ currentUserId: Int) {
        let url = Api.host + Api.Comments.Comment.postComment.path()
        let request = Api.makeRequest(url: url)
        let params: [String:Any] = ["comment":["commentroom_id":commentId, "user_id":currentUserId, "comment":"\(comment)"]]
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = jsonData
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: request as URLRequest, completionHandler: { (respData, resp, error) -> Void in
                if respData != nil {
                    let text = String(data: respData!, encoding: .utf8)
                }
            })
            task.resume()
        }catch{
            print(error.localizedDescription)
        }
        Thread.sleep(forTimeInterval: 0.5)
    }
}

