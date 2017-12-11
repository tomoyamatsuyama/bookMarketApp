//
//  BookViewModel.swift
//  
//
//  Created by 松山友也 on 2017/12/10.
//

import UIKit
import Foundation

extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksData.idLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.bind(cell: tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! BooksTableViewCell, index: indexPath.row)
        return cell
    }
}
