//
//  UserApi.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/17.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import Foundation

extension Api {
    struct Users {
        enum User {
            case signIn
            case signOut
            case edit
            case resister
            case getProfile(bookId: Int)
            
            func path() -> String {
                switch self {
                case .resister:
                    return "users.json"
                case .edit:
                    return "users.json"
                case .signIn:
                    return "users/sign_in.json"
                case .signOut:
                    return "users/sign_out.json"
                case let .getProfile(bookId):
                    return "users/\(bookId).json"
                }
            }
        }
    }
}
