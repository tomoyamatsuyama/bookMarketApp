//
//  AccountViewModel.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/11.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//
import Foundation
import UIKit

extension AccountViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountMenuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! UITableViewCell
        cell.textLabel?.text = accountMenuList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "アカウント情報"
    }
    
    
}
