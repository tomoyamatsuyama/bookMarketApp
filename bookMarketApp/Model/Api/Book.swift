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

struct BookDetail: Codable {
    var Book: BookInfo
    var CommentRoom: CommentRoomInfo
    struct BookInfo: Codable {
        struct Image: Codable {
            var url: String?
        }
        var id: Int
        var name: String
        var isbn: String
        var author: String
        var lesson: String
        var user_id: Int
        var user_name: String
        var money: Int
        var image1: Image
        var image2: Image
        var image3: Image
        var flag: Int
        var buy_id: Int?
        var updated_at: String
        var created_at: String
    }
    
    struct CommentRoomInfo: Codable {
        var id: Int
        var book_id: String
        var created_at: String
        var updated_at: String
    }
}

struct BookDetailData {
    var id: Int = 0
    var name: String = ""
    var author: String = ""
    var lesson: String = ""
    var userId: Int = 0
    var userName: String = ""
    var money: Int = 0
    var imageLists: Array<String?> = []
    var flag: Int = 0
    var buyId: Int? = nil
    var commentRoomId: Int = 0
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
    
    static func getBookDetail(bookId: Int) -> BookDetailData {
        var bookDetailData: BookDetailData = BookDetailData()
        let request = Api.getRequet(url: "http://localhost:3000/books/\(bookId).json")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let objects: BookDetail = try JSONDecoder().decode(BookDetail.self, from: data)
                bookDetailData.commentRoomId = objects.CommentRoom.id
                bookDetailData.id = objects.Book.id
                bookDetailData.name = objects.Book.name
                bookDetailData.author = objects.Book.author
                bookDetailData.lesson = objects.Book.lesson
                bookDetailData.money = objects.Book.money
                bookDetailData.userId = objects.Book.user_id
                bookDetailData.userName = objects.Book.user_name
                bookDetailData.buyId = objects.Book.buy_id
                bookDetailData.imageLists = [objects.Book.image1.url!, objects.Book.image2.url, objects.Book.image3.url]
            } catch let e {
                print(e)
            }
        }
        task.resume()
        Thread.sleep(forTimeInterval: 0.2)
        return bookDetailData
    }
    
    static func postPurchased(bookName: String, bookId: String, image1: String) {
        let request = Api.postRequest(url: "http://localhost:3000/rooms.json")
        let params: [String:Any] = ["room":["name":bookName, "book_id": bookId, "image1": image1]]
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = jsonData
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: request as URLRequest, completionHandler: { (respData, resp, error) -> Void in
                if respData != nil {
                    let text = String(data: respData!, encoding: .utf8)
                }
            })
            task.resume()
        }catch{
            print(error.localizedDescription)
        }
        Thread.sleep(forTimeInterval: 0.2)
    }
}
