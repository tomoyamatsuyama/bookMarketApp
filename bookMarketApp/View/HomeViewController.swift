//
//  HomeViewController.swift
//  
//
//  Created by 松山友也 on 2017/12/10.
//
import UIKit

class HomeViewController: UIViewController{
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var searchBar: UISearchBar!
    
    private var homeViewModel = HomeViewModel()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.refreshControl = refreshControl
        self.tableView.dataSource = homeViewModel
        refreshControl.addTarget(self, action: #selector(self.refreshControlValueChanged(sender:)), for: .valueChanged)
    }
    
    @objc func refreshControlValueChanged(sender: UIRefreshControl) {
        self.homeViewModel.getBook()
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            sender.endRefreshing()
        })
    }
    
    private func goToGoods(_ currentBookId: Int){
        let storyboard: UIStoryboard = UIStoryboard(name: "Goods", bundle: nil)
        let goodsView: GoodsViewController = storyboard.instantiateInitialViewController() as! GoodsViewController
        goodsView.instantiate(bookId: currentBookId)
        self.navigationController?.pushViewController(goodsView, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentBookId: Int = homeViewModel.booksData.idLists[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        goToGoods(currentBookId)
    }
}

