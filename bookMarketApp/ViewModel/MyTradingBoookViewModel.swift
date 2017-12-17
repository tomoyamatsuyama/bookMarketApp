//
//  MyTradingBoookViewModel.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/11.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//
import UIKit
import Foundation

class MyTradingBookViewModel: NSObject, UITableViewDataSource {
    public private(set) var tradingData = Book.getTradingData()
    
    func initialize(){
        self.tradingData = Book.getTradingData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tradingData.roomIdLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "myTradingCell", for: indexPath) as! BooksTableViewCell
        cell = cell.bind(cell, bookName: tradingData.bookNameLists[indexPath.row], lesson: tradingData.lessonLists[indexPath.row], author: tradingData.authorLists[indexPath.row], money: tradingData.moneyLists[indexPath.row], image: tradingData.imageLists[indexPath.row])
        return cell
    }
}

