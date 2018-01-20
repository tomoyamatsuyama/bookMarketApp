//
//  UserProfileViewModel.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/16.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//
import UIKit
import Foundation

class UserProfileViewModel: NSObject {
    public private(set) var userProfileData = ProfileData()
    
    func setUserProfile(completion: (() -> Void)? = nil){
        Api.Users.getProfileData(completion: { profile in
            self.userProfileData = profile
            UserDefaults.standard.set(profile.userName, forKey: Info.User.name.rawValue)
            UserDefaults.standard.set(profile.userEmail, forKey: Info.User.email.rawValue)
        })
        completion?()
    }
}
