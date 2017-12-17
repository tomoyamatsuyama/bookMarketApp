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

struct Message: Codable {
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

class MessageRoom{
    static func getMessageRoomId(bookId: Int) -> Int {
        var messageRoomId: Int = 0
        let url = Api.host + Api.Messages.Message.getMessageRoom(bookId: bookId).path()
        let request = Api.getRequet(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let objects: PurchasedBook = try JSONDecoder().decode(PurchasedBook.self, from: data)
                messageRoomId = objects.Room.id
            } catch let e {
                print(e)
            }
        }
        task.resume()
        Thread.sleep(forTimeInterval: 0.2)
        return messageRoomId
    }
    
    static func getMessage(messageRoomId: Int) -> MessageData {
        var messageData = MessageData()
        let url = Api.host + Api.Messages.Message.getMessage(messageRoomId: messageRoomId).path()
        let request = Api.getRequet(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let objects: Message = try JSONDecoder().decode(Message.self, from: data)
                objects.Messages.forEach { object in
                    messageData.userNameLists.append(object.user_name)
                    messageData.contentsLists.append(object.content)
                }
                messageData.bookId = objects.Room.book_id
                messageData.roomId = objects.Room.id
            } catch let e {
                print(e)
            }
        }
        task.resume()
        Thread.sleep(forTimeInterval: 0.3)
        return messageData
    }
    
    static func postMessage(message: String, roomId: String) {
        let url = Api.host + Api.Messages.Message.postMessage.path()
        let request = Api.makeRequest(url: url)
        let params: [String:Any] = ["message":["content": message, "room_id": roomId]]
        print("2",params)
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
        Thread.sleep(forTimeInterval: 0.2)
    }
}






