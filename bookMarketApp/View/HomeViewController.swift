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
    
    var booksData: BooksData = Book.getAll()
    private let refreshControl = UIRefreshControl()
    
    func reloadData(){
        booksData = Book.getAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refreshControlValueChanged(sender:)), for: .valueChanged)
    }
    
    @objc func refreshControlValueChanged(sender: UIRefreshControl) {
        booksData = Book.getAll()
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            sender.endRefreshing()
        })
    }
    
    func goToGoods(_ currentBookId: Int){
        let storyboard: UIStoryboard = UIStoryboard(name: "Goods", bundle: nil)
        let goodsView: GoodsViewController = storyboard.instantiateInitialViewController() as! GoodsViewController
        goodsView.selectedBookDetailData = Book.getBookDetail(bookId: currentBookId)
        self.navigationController?.pushViewController(goodsView, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        cell.titleLabel.text = booksData.nameLists[index]
        cell.lessonLabel.text = "授業名: \(booksData.lessonLists[index])"
        cell.authorLabel.text = "著者: \(booksData.authorLists[index])"
        cell.monneyLabel.text = "金額: \(booksData.moneyLists[index])"
        cell.imgView.image = self.checkImage(imageUrlString: booksData.imageLists["\(booksData.idLists[index])"]![0]!) //出品時に1枚は必須なので必ずnilではない。
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentBookId: Int = booksData.idLists[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        goToGoods(currentBookId)
    }
}

