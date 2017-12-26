//
//  MessageApi.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/17.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import Foundation

extension Api {
    struct Messages {
        enum Message {
            case getMessageRoom
            case getMessage
            case postMessage
            
            var path: String {
                switch self {
                case .getMessageRoom:
                    return "books/"
                case .getMessage:
                    return "rooms/"
                case .postMessage:
                    return "messages.json"
                }
            }
        }
        
        static func getMessageRoomId(bookId: Int, completion: ((Int) -> Void)? = nil) {
            var messageRoomId: Int = 0
            let path = Message.getMessageRoom.path + "\(bookId)" + ".json"
            guard let request = Api.makeRequest(url: Api.host + path, type: Api.RequestType.GET.rawValue) else { return }
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let objects: PurchasedBook = try JSONDecoder().decode(PurchasedBook.self, from: data)
                    messageRoomId = objects.Room.id
                    completion?(messageRoomId)
                } catch let e {
                    print(e)
                }
            }
            task.resume()
        }
        
        static func getMessage(messageRoomId: Int, completion: ((MessageData) -> Void)? = nil) {
            var messageData = MessageData()
            let path = Message.getMessage.path + "\(messageRoomId)" + ".json"
            guard let request = Api.makeRequest(url: Api.host + path, type: Api.RequestType.GET.rawValue) else { return }
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let objects: MessageModel = try JSONDecoder().decode(MessageModel.self, from: data)
                    objects.Messages.forEach { object in
                        messageData.userNameLists.append(object.user_name)
                        messageData.contentsLists.append(object.content)
                    }
                    messageData.bookId = objects.Room.book_id
                    messageData.roomId = objects.Room.id
                    DispatchQueue.main.async {
                        completion?(messageData)
                    }
                } catch let e {
                    print(e)
                }
            }
            task.resume()
        }
        
        static func postMessage(message: String, roomId: String, completion: ((Bool) -> Void)? = nil) {
            guard var request = Api.makeRequest(url: Api.host + Message.postMessage.path, type: Api.RequestType.POST.rawValue) else { return }
            let params: [String:Any] = ["message":["content": message, "room_id": roomId]]
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
                request.httpBody = jsonData
                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config)
                let task = session.dataTask(with: request as URLRequest, completionHandler: { (respData, resp, error) -> Void in
                    guard let response = resp else { return }
                    let isStatus = Api.checkResponse(response: response)
                    DispatchQueue.main.async {
                        completion?(isStatus)
                    }
                })
                task.resume()
            }catch{
                print(error.localizedDescription)
            }
        }
    }
}
