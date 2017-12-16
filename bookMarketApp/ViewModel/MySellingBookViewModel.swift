//
//  MySellingBookViewModel.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/11.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//
import UIKit
import Foundation

class MySellingBookViewModel: NSObject, UITableViewDataSource {
    private var sellingData = ProfileData()
    
    func initialize(){
        self.sellingData = Users.getProfileData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sellingData.idLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "mySellingCell", for: indexPath) as! BooksTableViewCell
        cell = cell.bind(cell, bookName: sellingData.nameLists[indexPath.row], lesson: sellingData.lessonLists[indexPath.row], author: sellingData.authorLists[indexPath.row], money: sellingData.moneyLists[indexPath.row], image: sellingData.imageLists["\(sellingData.idLists[indexPath.row])"]![0]!)
        return cell
    }
}
