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
    
    static func instatiate() -> MySellingBookViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "MySellingBook", bundle: nil)
        let mySellingBookView = storyboard.instantiateInitialViewController() as! MySellingBookViewController
        return mySellingBookView
    }
    
    private func reloadData(){
        mySellingViewModel.setSellingData(comp: { [weak self] in
            guard let `self` = self else { return }
            self.mySellingTableView.reloadData()
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mySellingTableView.refreshControl = refreshControl
        mySellingTableView.dataSource = mySellingViewModel
        reloadData()
        refreshControl.addTarget(self, action: #selector(self.refreshControlValueChanged(sender:)), for: .valueChanged)
    }
    
    @objc func refreshControlValueChanged(sender: UIRefreshControl) {
        reloadData()
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
