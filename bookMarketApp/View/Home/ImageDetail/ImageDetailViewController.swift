//
//  ImageDetailViewController.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/11.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    private var imageDetailVM = ImageDetailViewModel()
    
    static func instantiate(image: UIImage) -> ImageDetailViewController {
        let storyboard = UIStoryboard(name: "ImageDetail", bundle: nil)
        let imageDetailView = storyboard.instantiateInitialViewController() as! ImageDetailViewController
        imageDetailView.imageDetailVM.initialize(selectedImage: image)
        return imageDetailView
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = imageDetailVM.image
    }
}
