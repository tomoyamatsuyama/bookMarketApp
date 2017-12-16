//
//  BookViewModel.swift
//  
//
//  Created by 松山友也 on 2017/12/10.
//

import UIKit
import Foundation

class HomeViewModel: NSObject, UITableViewDataSource {
    var booksData: BooksData = Book.getAll()
    func getBook(){
        booksData = Book.getAll()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksData.idLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! BooksTableViewCell
        cell = cell.bind(cell, bookName: booksData.nameLists[indexPath.row], lesson: booksData.lessonLists[indexPath.row], author: booksData.authorLists[indexPath.row], money: booksData.moneyLists[indexPath.row], image: booksData.imageLists["\(booksData.idLists[indexPath.row])"]![0]!)
        return cell
    }
}

