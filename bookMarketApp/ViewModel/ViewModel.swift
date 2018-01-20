//
//  ViewModel.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/16.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//
import UIKit
import Foundation

extension UIViewController {
    func goToHome(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainView = mainStoryboard.instantiateInitialViewController() as! UITabBarController
        self.present(mainView, animated: true, completion: nil)
    }
    
    func goToImageShow(image: UIImage) {
        let imageDetailView = ImageDetailViewController.instantiate(image: image)
        self.present(imageDetailView, animated: true, completion: nil)
    }
    
    func imageSet(imageUrlString: String) -> UIImage? {
        guard let imageUrl = URL(string: Api.host + "\(imageUrlString)") else { return nil}
        do {
            let imageData = try NSData(contentsOf: imageUrl, options: NSData.ReadingOptions.mappedIfSafe)
            guard let img = UIImage(data: imageData as Data) else { return nil}
            return img
        } catch {
            print("Error: can't create image.")
        }
        return nil
    }
}
