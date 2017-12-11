//
//  GoodsViewController.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/11.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import UIKit

class GoodsViewController: UIViewController {
    var selectedBookDetailData: BookDetailData = BookDetailData()
    @IBOutlet weak private var imageView1: UIImageView!
    @IBOutlet weak private var imageView2: UIImageView!
    @IBOutlet weak private var imageView3: UIImageView!
    @IBOutlet weak private var goodsTableView: UITableView!
    
    @IBAction func commentButton(_ sender: Any) {
    }
    
    @IBAction func buyButton(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "購入しますか？", message: "商品名: \(selectedBookDetailData.name)\n 値段: \(selectedBookDetailData.money)", preferredStyle:  UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "購入", style: UIAlertActionStyle.default, handler:{(action: UIAlertAction!) -> Void in
            self.GoToPurchased()
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{(action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    func GoToPurchased(){
        Book.postPurchased(bookName: selectedBookDetailData.name, bookId: "\(selectedBookDetailData.id)", image1: selectedBookDetailData.imageLists[0]!)
        let storyboard: UIStoryboard = UIStoryboard(name: "PurchasedGoods", bundle: nil)
        if let purchasedGoodsView: PurchasedGoodsViewController = storyboard.instantiateInitialViewController() as? PurchasedGoodsViewController {
            purchasedGoodsView.purchasedBookDetailData = Book.getBookDetail(bookId: selectedBookDetailData.id)
            self.navigationController?.pushViewController(purchasedGoodsView , animated: true)
        }
    }
    
    private func goToImageShow(image: UIImage){
        let storyboard: UIStoryboard = UIStoryboard(name: "ImageDetail", bundle: nil)
        let imageDetailView: ImageDetailViewController = storyboard.instantiateInitialViewController() as! ImageDetailViewController
        imageDetailView.image = image
        self.present(imageDetailView, animated: true, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch: UITouch in touches {
            let tag = touch.view!.tag
            switch tag {
            case 1:
                goToImageShow(image: imageView1.image!)
            case 2:
                goToImageShow(image: imageView2.image!)
            case 3:
                goToImageShow(image: imageView3.image!)
            default:
                break
            }
        }
    }
    
    private func imageSet(imageUrlString: String) -> UIImage{
        guard let imageUrl: URL = URL(string: "http://localhost:3000/\(imageUrlString)") else { return UIImage()}
        do {
            let imageData = try NSData(contentsOf: imageUrl, options: NSData.ReadingOptions.mappedIfSafe)
            guard let img = UIImage(data: imageData as Data) else { return UIImage()}
            return img
        } catch {
            print("Error: can't create image.")
        }
        return UIImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = selectedBookDetailData.name
        self.imageView1.image = imageSet(imageUrlString: selectedBookDetailData.imageLists[0]!) //出品時に1枚は必須なのでforce unwrap
        if let imageString2: String = selectedBookDetailData.imageLists[1] {
            self.imageView2.image = imageSet(imageUrlString: imageString2)
        }
        if let imageString3: String = selectedBookDetailData.imageLists[2] {
            self.imageView3.image = imageSet(imageUrlString: imageString3)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
