//
//  GoodsViewModel.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/11.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import UIKit
import Foundation

extension GoodsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goodsCell", for: indexPath) as! UITableViewCell
        let goodsList: [String] = ["タイトル: \(selectedBookDetailData.name)", "著者: \(selectedBookDetailData.author)", "授業名: \(selectedBookDetailData.lesson)", "出品者: \(selectedBookDetailData.userName)", "金額: \(selectedBookDetailData.money)"]
        cell.textLabel?.text = goodsList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}
