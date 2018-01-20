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
    private var myTradingBookVM = MyTradingBookViewModel()
    
    static func instatiate() -> MyTradingBookViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "MyTradingBook", bundle: nil)
        let myTradingBookView = storyboard.instantiateInitialViewController() as! MyTradingBookViewController
        return myTradingBookView
    }
    
    private func reloadTradingData() {
        myTradingBookVM.setTradingData(completion: { [weak self] in
            guard let `self` = self else { return }
            self.myTradingTableView.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTradingTableView.refreshControl = refreshControl
        myTradingTableView.dataSource = myTradingBookVM
        reloadTradingData()
        refreshControl.addTarget(self, action: #selector(self.refreshControlValueChanged(sender:)), for: .valueChanged)
    }

    @objc func refreshControlValueChanged(sender: UIRefreshControl) {
        reloadTradingData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            sender.endRefreshing()
        })
    }

    func goToPurchased(selectedCell: Int) {
        let purchasedGoodsView = PurchasedGoodsViewController.instantiate(currentBookId: selectedCell)
        self.navigationController?.pushViewController(purchasedGoodsView , animated: true)
    }
}

extension MyTradingBookViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedId: Int = myTradingBookVM.tradingData.bookIdLists[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        goToPurchased(selectedCell: selectedId)
    }
}
