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
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainView = mainStoryboard.instantiateInitialViewController() as! UITabBarController
        self.present(mainView, animated: true, completion: nil)
    }
    
    func goToImageShow(image: UIImage){
        let storyboard: UIStoryboard = UIStoryboard(name: "ImageDetail", bundle: nil)
        let imageDetailView: ImageDetailViewController = storyboard.instantiateInitialViewController() as! ImageDetailViewController
        imageDetailView.instantiate(image: image)
        self.present(imageDetailView, animated: true, completion: nil)
    }
    
    func imageSet(imageUrlString: String) -> UIImage? {
        guard let imageUrl: URL = URL(string: "http://localhost:3000/\(imageUrlString)") else { return nil}
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
