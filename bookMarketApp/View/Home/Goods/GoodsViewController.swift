//
//  GoodsViewController.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/11.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import UIKit

class GoodsViewController: UIViewController {
    @IBOutlet weak private var imageView1: UIImageView!
    @IBOutlet weak private var imageView2: UIImageView!
    @IBOutlet weak private var imageView3: UIImageView!
    @IBOutlet weak private var goodsTableView: UITableView!
    
    private var goodsVM = GoodsViewModel()
    private var bookId = 0
    
    static func instantiate(bookId: Int) -> GoodsViewController {
        let storyboard = UIStoryboard(name: "Goods", bundle: nil)
        let goodsView = storyboard.instantiateInitialViewController() as! GoodsViewController
        goodsView.goodsVM.initiaize(bookId: bookId)
        return goodsView
    }

    @IBAction func rightSwiped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
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
    
    private func setImage(){
        self.imageView1.image = imageSet(imageUrlString: goodsVM.booksData.imageLists[0]!) //出品時に1枚は必須なのでforce unwrap
        
        guard let imageString2 = goodsVM.booksData.imageLists[1] else {return}
        self.imageView2.image = imageSet(imageUrlString: imageString2)
        guard let imageString3 = goodsVM.booksData.imageLists[2] else {return}
        self.imageView3.image = imageSet(imageUrlString: imageString3)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goodsVM.getBook(completion: { [weak self] in
            guard let `self` = self else { return }
            self.setImage()
            self.navigationItem.title = self.goodsVM.booksData.name
            self.goodsTableView.reloadData()
        })
        self.goodsTableView.dataSource = goodsVM
    }
    
    @IBAction func commentButton(_ sender: Any) {
        let commentVC = CommentViewController.instantiate(roomId: goodsVM.booksData.commentRoomId, bookId: goodsVM.currentBookId)
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    @IBAction func buyButton(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "購入しますか？", message: "商品名: \(goodsVM.booksData.name)\n 値段: \(goodsVM.booksData.money)", preferredStyle:  UIAlertControllerStyle.alert)
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
    
    private func GoToPurchased(){
        Api.Books.postPurchased(bookName: goodsVM.booksData.name, bookId: String(goodsVM.booksData.id), image1: goodsVM.booksData.imageLists[0]!, completion: { isStatus in
            if isStatus == false {
                return
            } else if isStatus == true {
                let purchasedGoodsVC = PurchasedGoodsViewController.instantiate(currentBookId: self.goodsVM.currentBookId)
                self.navigationController?.pushViewController(purchasedGoodsVC , animated: true)
            }
        })
    }
}

extension GoodsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
