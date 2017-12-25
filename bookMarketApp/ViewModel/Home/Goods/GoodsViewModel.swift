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
    
    func initiaize(bookId: Int) {
        self.currentBookId = bookId
    }
    
    func getBook(completion: (() -> Void)? = nil) {
        Api.Books.getBookDetail(bookId: currentBookId, completion: { bookData in
            self.booksData = bookData
            completion?()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goodsCell", for: indexPath)
        let goodsList: [String] = [String(format: NSLocalizedString("title", comment: ""), booksData.name), String(format: NSLocalizedString("author", comment: ""), booksData.author), String(format: NSLocalizedString("lesson", comment: ""), booksData.lesson),String(format: NSLocalizedString("seller", comment: ""), booksData.userName),String(format: NSLocalizedString("money", comment: ""), booksData.money)]
        cell.textLabel?.text = goodsList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}

