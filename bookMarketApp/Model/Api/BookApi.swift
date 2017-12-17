//
//  BookApi.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/17.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import Foundation

extension Api {
    struct Books {
        enum Book {
            case bookAll
            case bookDetail(bookId: Int)
            case postPurchased
            case finishTrade(buyId: Int)
            case getTrading
            
            func path() -> String {
                switch self {
                case .bookAll:
                    return "books.json"
                case let .bookDetail(bookId):
                    return "books/\(bookId).json"
                case .postPurchased:
                    return "rooms.json"
                case let .finishTrade(buyId):
                    return "buys/\(buyId).json"
                case .getTrading:
                    return "rooms.json"
                }
            }
        }
    }
}
