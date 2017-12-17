//
//  CommentApi.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/17.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import Foundation

extension Api {
    struct Comments {
        enum Comment {
            case getCommentRoom(commentRoomId: Int)
            case postComment
            
            func path() -> String {
                switch self {
                case let .getCommentRoom(commentRoomId):
                    return "commentrooms/\(commentRoomId).json"
                case .postComment:
                    return "comments.json"
                }
            }
        }
    }
}
