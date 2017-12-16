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
        self.purchasedBookDetailData = Book.getBookDetail(bookId: bookId)
        self.currentBookId = bookId
        self.messageRoomId = MessageRoom.getMessageRoomId(bookId: bookId)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "purchasedCell", for: indexPath)
        let goodsList: [String] = ["タイトル: \(purchasedBookDetailData.name)", "著者: \(purchasedBookDetailData.author)", "授業名: \(purchasedBookDetailData.lesson)", "出品者: \(purchasedBookDetailData.userName)", "金額: \(purchasedBookDetailData.money)"]
        cell.textLabel?.text = goodsList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}

