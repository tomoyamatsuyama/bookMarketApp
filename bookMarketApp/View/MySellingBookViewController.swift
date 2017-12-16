//
//  MySellingBookViewController.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/11.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//
import UIKit
class MySellingBookViewController: UIViewController {
    @IBOutlet weak var mySellingTableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    private var mySellingViewModel = MySellingBookViewModel()
    
    func instatiate(){
        mySellingViewModel.initialize()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mySellingTableView.refreshControl = refreshControl
        mySellingTableView.dataSource = mySellingViewModel
        refreshControl.addTarget(self, action: #selector(self.refreshControlValueChanged(sender:)), for: .valueChanged)
    }
    
    @objc func refreshControlValueChanged(sender: UIRefreshControl) {
        mySellingViewModel.initialize()
        mySellingTableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            sender.endRefreshing()
        })
    }
}

extension MySellingBookViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
