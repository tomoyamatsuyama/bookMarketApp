//
//  Book.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/10.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import Foundation

struct BooksAll: Codable {
    var Books: [Books]
    var CurrentUser: User
    struct Books: Codable {
        struct Image: Codable {
            var url: String?
        }
        var id: Int
        var name: String
        var isbn: String
        var author: String
        var lesson: String
        var user_id: Int
        var money: Int
        var image1: Image
        var image2: Image
        var image3: Image
        var flag: Int
        var buy_id: Int?
        var user_name: String
        var created_at: String
        var updated_at: String
    }
    struct User: Codable {
        var id: Int
        var email: String
        var encrypted_password: String
        var user_name: String
        var created_at: String
        var updated_at: String
    }
}

struct BooksData {
    var idLists: [Int] = []
    var authorLists:[String] = []
    var lessonLists: [String] = []
    var moneyLists: [Int] = []
    var nameLists: [String] = []
    var userIdLists: [Int] = []
    var userNameLists: [String] = []
    var imageLists: [String : Array<String?>] = [:]
    var commentRoomsId: [Int] = []
}

class Book{
    static func getAll() -> BooksData{
        var booksData: BooksData = BooksData()
        let request = Api.getRequet(url: "http://localhost:3000/books.json")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let objects: BooksAll = try JSONDecoder().decode(BooksAll.self, from: data)
                objects.Books.forEach { object in
                    if object.flag == 0 {
                        booksData.idLists.append(object.id)
                        booksData.authorLists.append(object.author)
                        booksData.lessonLists.append(object.lesson)
                        booksData.moneyLists.append(object.money)
                        booksData.nameLists.append(object.name)
                        booksData.userIdLists.append(object.user_id)
                        booksData.userNameLists.append(object.user_name)
                        booksData.imageLists["\(object.id)"] = [object.image1.url!, object.image2.url, object.image3.url]
                    }
                }
            } catch let e {
                print(e)
            }
        }
        task.resume()
        Thread.sleep(forTimeInterval: 0.4)
        return booksData
    }
}
