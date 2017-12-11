//
//  MyTradingBookViewController.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/11.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//
import UIKit
class MyTradingBookViewController: UIViewController {
    var tradingData = Users.getTradingData()
    @IBOutlet weak var myTradingTableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTradingTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refreshControlValueChanged(sender:)), for: .valueChanged)
    }

    @objc func refreshControlValueChanged(sender: UIRefreshControl) {
        tradingData = Users.getTradingData()
        myTradingTableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            sender.endRefreshing()
        })
    }
    
    private func checkImage(imageUrlString: String) -> UIImage? {
        let imageUrl: URL = URL(string: "http://localhost:3000/\(imageUrlString)")!
        do {
            let imageData = try NSData(contentsOf: imageUrl, options: NSData.ReadingOptions.mappedIfSafe)
            let img = UIImage(data: imageData as Data)
            return img
        } catch {
            print("Error: can't create image.")
            return UIImage()
        }
    }
    
    func bind(cell: BooksTableViewCell, index: Int) -> BooksTableViewCell{
        cell.titleLabel.text = tradingData.bookNameLists[index]
        cell.lessonLabel.text = "授業名: \(tradingData.lessonLists[index])"
        cell.authorLabel.text = "著者: \(tradingData.authorLists[index])"
        cell.monneyLabel.text = "金額: \(tradingData.moneyLists[index])"
        cell.imgView.image = self.checkImage(imageUrlString: tradingData.imageLists[index])
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func goToPurchased(selectedCell: Int){
        let storyboard: UIStoryboard = UIStoryboard(name: "PurchasedGoods", bundle: nil)
        if let purchasedGoodsView: PurchasedGoodsViewController = storyboard.instantiateInitialViewController() as? PurchasedGoodsViewController {
            purchasedGoodsView.purchasedBookDetailData = Book.getBookDetail(bookId: selectedCell)
            self.navigationController?.pushViewController(purchasedGoodsView , animated: true)
        }
    }
}

extension MyTradingBookViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedId: Int = tradingData.bookIdLists[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        goToPurchased(selectedCell: selectedId)
    }
}
