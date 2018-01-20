//
//  ImageDetailViewModel.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/16.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//
import UIKit
import Foundation

class ImageDetailViewModel: NSObject {
    public private(set) var image: UIImage = UIImage()
    
    func initialize(selectedImage: UIImage) {
        self.image = selectedImage
    }
}
