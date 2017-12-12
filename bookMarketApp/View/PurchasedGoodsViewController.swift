//
//  PurchasedGoodsViewController.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/11.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import UIKit

class PurchasedGoodsViewController: UIViewController {
    var purchasedBookDetailData: BookDetailData = BookDetailData()
    @IBOutlet weak private var imageView1: UIImageView!
    @IBOutlet weak private var imageView2: UIImageView!
    @IBOutlet weak private var imageView3: UIImageView!
    @IBOutlet weak private var purchasedTableView: UITableView!
    
    @IBAction private func rightSwiped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func goToMessage(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Message", bundle: nil)
        let messageView = storyboard.instantiateInitialViewController() as! MessageViewController
        let roomId = MessageRoom.getMessageRoomId(bookId: purchasedBookDetailData.id)
        messageView.messageData = MessageRoom.getMessage(messageRoomId: roomId)
        messageView.roomId = roomId
        self.navigationController?.pushViewController(messageView, animated: true)
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
    
    @IBAction func tranzactionConpleteButton(_ sender: Any) {
        transactionConplete()
    }
    private func transactionConplete(){
        guard let buyId = purchasedBookDetailData.buyId else { return }
        let errorText = Book.finishTrade(buyId: buyId)
        if errorText.contains("error"){
            return
        } else {
            goToHome()
        }
    }
    
    
    
    private func goToHome(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainView = mainStoryboard.instantiateInitialViewController() as! UITabBarController
        self.present(mainView, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = purchasedBookDetailData.name
        self.imageView1.image = imageSet(imageUrlString: purchasedBookDetailData.imageLists[0]!)
        
        if let imageString2: String = purchasedBookDetailData.imageLists[1] {
            self.imageView2.image = imageSet(imageUrlString: imageString2)
        }
        
        if let imageString3: String = purchasedBookDetailData.imageLists[2] {
            self.imageView3.image = imageSet(imageUrlString: imageString3)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PurchasedGoodsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
