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
    
    override init(){
        self.userProfileData = Users.getProfileData()
    }
}
