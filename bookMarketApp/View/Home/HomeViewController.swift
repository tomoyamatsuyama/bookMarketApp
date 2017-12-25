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
    
    func reloadData(){
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.refreshControl = refreshControl
        self.tableView.dataSource = homeViewModel
        self.homeViewModel.getBook() { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.tableView.reloadData()
        }
        refreshControl.addTarget(self, action: #selector(self.refreshControlValueChanged(sender:)), for: .valueChanged)
        
        /*
         TODO: RxSwift
        let disposeBag = DisposeBag()
         tableView.rx.cell...
            .drive(homeViewModel.booksData)
            .dispose(disposeBag)
        */
    }
    
    @objc func refreshControlValueChanged(sender: UIRefreshControl) {
        self.homeViewModel.getBook() { [weak self] in
            guard let `self` = self else { return }
            self.tableView.reloadData()
        }
        // [weak self]  / [unowned self] / なんもなし
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            sender.endRefreshing()
        }
    }
    
    private func goToGoods(currentBookId: Int) {
        let goodsView = GoodsViewController.instantiate(bookId: currentBookId)
        self.navigationController?.pushViewController(goodsView, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentBookId = homeViewModel.getBookId(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        goToGoods(currentBookId: currentBookId)
    }
}

