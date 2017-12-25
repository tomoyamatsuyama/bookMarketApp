//
//  AuthApi.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/17.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import Foundation

extension Api {
    struct Auth {
        enum Authorization {
            case signIn
            
            var path: String {
                switch self {
                case .signIn:
                    return "users/sign_in.json"
                }
            }
        }
    }
}
