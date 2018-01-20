//
//  BooksTableViewCell.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/10.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import UIKit

class BooksTableViewCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var lessonLabel: UILabel!
    @IBOutlet weak var monneyLabel: UILabel!
    
    private func checkImage(imageUrlString: String) -> UIImage? {
        guard let imageUrl: URL = URL(string: Api.host + "\(imageUrlString)") else { return nil }
        do {
            let imageData = try NSData(contentsOf: imageUrl, options: NSData.ReadingOptions.mappedIfSafe)
            let img = UIImage(data: imageData as Data)
            return img
        } catch {
            print("Error: can't create image.")
            return nil
        }
    }
    
    func bind(_ cell: BooksTableViewCell, bookName: String, lesson: String, author: String, money: Int, image: String) -> BooksTableViewCell {
        cell.titleLabel.text = bookName
        // localized.strings
        cell.lessonLabel.text = String(format: NSLocalizedString("lesson", comment: ""), lesson)
        cell.authorLabel.text = String(format: NSLocalizedString("author", comment: ""), author)
        cell.monneyLabel.text = String(format: NSLocalizedString("money", comment: ""), money)
        cell.imgView.image = self.checkImage(imageUrlString: image) //出品時に1枚は必須なので必ずnilではない。
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
