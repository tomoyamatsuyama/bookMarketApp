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
            case getMessageRoom(bookId: Int)
            case getMessage(messageRoomId: Int)
            case postMessage
            
            func path() -> String {
                switch self {
                case let .getMessageRoom(bookId):
                    return "books/\(bookId).json"
                case let .getMessage(messageRoomId):
                    return "rooms/\(messageRoomId).json"
                case .postMessage:
                    return "messages.json"
                }
            }
        }
    }
}
