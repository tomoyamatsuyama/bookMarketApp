//
//  MySellingBookViewController.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/11.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//
import UIKit
class MySellingBookViewController: UIViewController {
    var sellingData = ProfileData()
    @IBOutlet weak var mySellingTableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
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
        cell.titleLabel.text = sellingData.nameLists[index]
        cell.lessonLabel.text = "授業名: \(sellingData.lessonLists[index])"
        cell.authorLabel.text = "著者: \(sellingData.authorLists[index])"
        cell.monneyLabel.text = "金額: \(sellingData.moneyLists[index])"
        cell.imgView.image = self.checkImage(imageUrlString: sellingData.imageLists["\(sellingData.idLists[index])"]![0]!) //出品時に1枚は必須なので必ずnilではない。
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mySellingTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refreshControlValueChanged(sender:)), for: .valueChanged)
    }
    
    @objc func refreshControlValueChanged(sender: UIRefreshControl) {
        sellingData = Users.getProfileData()
        mySellingTableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            sender.endRefreshing()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension MySellingBookViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
