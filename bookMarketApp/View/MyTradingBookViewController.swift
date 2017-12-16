//
//  MyTradingBookViewController.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/11.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//
import UIKit
class MyTradingBookViewController: UIViewController {
    @IBOutlet weak var myTradingTableView: UITableView!
    private let refreshControl = UIRefreshControl()
    fileprivate var myTradingBookViewModel = MyTradingBookViewModel()
    
    func instatiate(){
        myTradingBookViewModel.initialize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTradingTableView.refreshControl = refreshControl
        myTradingTableView.dataSource = myTradingBookViewModel
        refreshControl.addTarget(self, action: #selector(self.refreshControlValueChanged(sender:)), for: .valueChanged)
    }

    @objc func refreshControlValueChanged(sender: UIRefreshControl) {
        myTradingBookViewModel.initialize()
        myTradingTableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            sender.endRefreshing()
        })
    }

    func goToPurchased(selectedCell: Int){
        let storyboard: UIStoryboard = UIStoryboard(name: "PurchasedGoods", bundle: nil)
        let purchasedGoodsView: PurchasedGoodsViewController = storyboard.instantiateInitialViewController() as! PurchasedGoodsViewController
        purchasedGoodsView.instantiate(currentBookId: selectedCell)
        self.navigationController?.pushViewController(purchasedGoodsView , animated: true)
    }
}

extension MyTradingBookViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedId: Int = myTradingBookViewModel.tradingData.bookIdLists[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        goToPurchased(selectedCell: selectedId)
    }
}
