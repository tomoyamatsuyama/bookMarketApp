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
    
    private var goodsViewModel = GoodsViewModel()
    
    func instantiate(bookId: Int){
        goodsViewModel.getBook(bookId: bookId)
    }
    
    @IBAction func rightSwiped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
    
    private func setImage(){
        self.imageView1.image = imageSet(imageUrlString: goodsViewModel.booksData.imageLists[0]!) //出品時に1枚は必須なのでforce unwrap
        guard let imageString2: String = goodsViewModel.booksData.imageLists[1] else {return}
        self.imageView2.image = imageSet(imageUrlString: imageString2)
        guard let imageString3: String = goodsViewModel.booksData.imageLists[2] else {return}
        self.imageView3.image = imageSet(imageUrlString: imageString3)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = goodsViewModel.booksData.name
        self.goodsTableView.dataSource = goodsViewModel
    }
    
    @IBAction func commentButton(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Comment", bundle: nil)
        let commentView: CommentViewController = storyboard.instantiateInitialViewController() as! CommentViewController
        commentView.instantiate(roomId: goodsViewModel.booksData.commentRoomId, bookId: goodsViewModel.currentBookId)
        self.navigationController?.pushViewController(commentView, animated: true)
    }
    
    @IBAction func buyButton(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "購入しますか？", message: "商品名: \(goodsViewModel.booksData.name)\n 値段: \(goodsViewModel.booksData.money)", preferredStyle:  UIAlertControllerStyle.alert)
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
        Book.postPurchased(bookName: goodsViewModel.booksData.name, bookId: String(goodsViewModel.booksData.id), image1: goodsViewModel.booksData.imageLists[0]!)
        let storyboard: UIStoryboard = UIStoryboard(name: "PurchasedGoods", bundle: nil)
        let purchasedGoodsView: PurchasedGoodsViewController = storyboard.instantiateInitialViewController() as! PurchasedGoodsViewController
        purchasedGoodsView.instantiate(currentBookId: goodsViewModel.currentBookId)
        self.navigationController?.pushViewController(purchasedGoodsView , animated: true)
    }
}

extension GoodsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
