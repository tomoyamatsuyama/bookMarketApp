//
//  GoodsViewModel.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/11.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import UIKit
import Foundation

class GoodsViewModel: NSObject, UITableViewDataSource {
    public private(set) var booksData: BookDetailData = BookDetailData()
    public private(set) var currentBookId = 0
    
    func getBook(bookId: Int){
        self.currentBookId = bookId
        self.booksData = Book.getBookDetail(bookId: bookId)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goodsCell", for: indexPath)
        let goodsList: [String] = ["タイトル: \(booksData.name)", "著者: \(booksData.author)", "授業名: \(booksData.lesson)", "出品者: \(booksData.userName)", "金額: \(booksData.money)"]
        cell.textLabel?.text = goodsList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}

