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
    
    func reloadData(){
        booksData = Book.getAll()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func checkImage(imageUrlString: String) -> UIImage? {
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
        print()
        cell.titleLabel.text = booksData.nameLists[index]
        cell.lessonLabel.text = "授業名: \(booksData.lessonLists[index])"
        cell.authorLabel.text = "著者: \(booksData.authorLists[index])"
        cell.monneyLabel.text = "金額: \(booksData.moneyLists[index])"
        cell.imgView.image = checkImage(imageUrlString: booksData.imageLists["\(booksData.idLists[index])"]![0]!) //出品時に1枚は必須なので必ずnilではない。
        return cell
    }
}

//extension HomeViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let currentBookId: Int = booksData.idLists[indexPath.row]
//        tableView.deselectRow(at: indexPath, animated: true)
////        self.performSegue(withIdentifier: "NextToGoods", sender: currentBookId)
//    }
//}

