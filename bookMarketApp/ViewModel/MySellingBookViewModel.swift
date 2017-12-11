//
//  MySellingBookViewModel.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/11.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//
import UIKit
import Foundation

extension MySellingBookViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sellingData.idLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.bind(cell: tableView.dequeueReusableCell(withIdentifier: "mySellingCell", for: indexPath) as! BooksTableViewCell, index: indexPath.row)
        return cell
    }
}
