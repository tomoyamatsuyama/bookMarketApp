//
//  PurchasedGoodsViewController.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/11.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import UIKit

class PurchasedGoodsViewController: UIViewController {
    @IBOutlet weak private var imageView1: UIImageView!
    @IBOutlet weak private var imageView2: UIImageView!
    @IBOutlet weak private var imageView3: UIImageView!
    @IBOutlet weak private var purchasedTableView: UITableView!
    
    private var purchasedGoodsViewModel = PurchasedGoodsViewModel()
    
    func instantiate(currentBookId: Int){
        purchasedGoodsViewModel.initialize(bookId: currentBookId)
    }
    
    @IBAction private func rightSwiped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func goToMessage(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Message", bundle: nil)
        let messageView = storyboard.instantiateInitialViewController() as! MessageViewController
        messageView.instantiate(currentBookId: purchasedGoodsViewModel.currentBookId, currentMessageRoomId: purchasedGoodsViewModel.messageRoomId)
        self.navigationController?.pushViewController(messageView, animated: true)
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
    
    @IBAction func tranzactionConpleteButton(_ sender: Any) {
        transactionConplete()
    }
    
    private func transactionConplete(){
        guard let buyId = purchasedGoodsViewModel.purchasedBookDetailData.buyId else { return }
        let errorText = Book.finishTrade(buyId: buyId)
        if errorText.contains("error"){
            return
        } else {
            goToHome()
        }
    }
    
    private func setImage(){
        self.imageView1.image = imageSet(imageUrlString: purchasedGoodsViewModel.purchasedBookDetailData.imageLists[0]!)
        guard let imageString2: String = purchasedGoodsViewModel.purchasedBookDetailData.imageLists[1] else {return}
        self.imageView2.image = imageSet(imageUrlString: imageString2)
        guard let imageString3: String = purchasedGoodsViewModel.purchasedBookDetailData.imageLists[2] else {return}
        self.imageView3.image = imageSet(imageUrlString: imageString3)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.purchasedTableView.dataSource = purchasedGoodsViewModel
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = purchasedGoodsViewModel.purchasedBookDetailData.name
        setImage()
    }
}

extension PurchasedGoodsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
