//
//  PurchasedGoodsViewModel.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/11.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//
import UIKit
import Foundation

class PurchasedGoodsViewModel: NSObject,UITableViewDataSource {
    public private(set) var purchasedBookDetailData: BookDetailData = BookDetailData()
    public private(set) var currentBookId = 0
    public private(set) var messageRoomId = 0
    
    func initialize(bookId: Int){
        self.currentBookId = bookId
        setMessageRoomId()
    }
    
    func setPurchasedData(completion: (() -> Void)? = nil) {
        Api.Books.getBookDetail(bookId: currentBookId, completion: { bookData in
            self.purchasedBookDetailData = bookData
            completion?()
        })
    }
    
    func setMessageRoomId(){
        Api.Messages.getMessageRoomId(bookId: currentBookId, completion: { mgRoomId in
            self.messageRoomId = mgRoomId
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "purchasedCell", for: indexPath)
        let goodsList: [String] = [String(format: NSLocalizedString("title", comment: ""), purchasedBookDetailData.name), String(format: NSLocalizedString("author", comment: ""), purchasedBookDetailData.author), String(format: NSLocalizedString("lesson", comment: ""), purchasedBookDetailData.lesson), String(format: NSLocalizedString("seller", comment: ""), purchasedBookDetailData.userName), String(format: NSLocalizedString("money", comment: ""), purchasedBookDetailData.money)]
        cell.textLabel?.text = goodsList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}

