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
    static var currentUserId: Int = 0
    
    static func getAll() -> BooksData{
        var booksData: BooksData = BooksData()
        let url = Api.host + Api.Books.Book.bookAll.path()
        let request = Api.getRequet(url: url)
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
                currentUserId = objects.CurrentUser.id
            } catch let e {
                print(e)
            }
        }
        task.resume()
        Thread.sleep(forTimeInterval: 0.4)
        return booksData
    }
    
    static func getBookDetail(bookId: Int) -> BookDetailData{
        var bookDetailData: BookDetailData = BookDetailData()
        let url = Api.host + Api.Books.Book.bookDetail(bookId: bookId).path()
        let request = Api.getRequet(url: url)
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
        let url = Api.host + Api.Books.Book.postPurchased.path()
        let request = Api.makeRequest(url: url)
        let params: [String:Any] = ["room":["name":bookName, "book_id": bookId, "image1": image1]]
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = jsonData
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: request as URLRequest, completionHandler: { (respData, resp, error) -> Void in
                
            })
            task.resume()
        }catch{
            print(error.localizedDescription)
        }
        Thread.sleep(forTimeInterval: 0.2)
    }
    
    static func getTradingData() -> TradingData{
        var tradingData = TradingData()
        let url = Api.Books.Book.getTrading.path()
        let request = Api.getRequet(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let objects: Trading = try JSONDecoder().decode(Trading.self, from: data)
                objects.Room.forEach { object in
                    if objects.CurrentUser.id == object.user_id || objects.CurrentUser.id == object.user_2 {
                        tradingData.roomIdLists.append(object.id)
                        tradingData.bookIdLists.append(object.book_id)
                        tradingData.userFirstIdLists.append(object.user_id)
                        tradingData.userSecondIdLists.append(object.user_2)
                        tradingData.bookNameLists.append(object.name)
                        tradingData.imageLists.append(object.image1)
                        tradingData.authorLists.append(object.author)
                        tradingData.lessonLists.append(object.lesson)
                        tradingData.moneyLists.append(object.money)
                        tradingData.buyIdLists.append(object.buy_id)
                    }
                }
                tradingData.currentUserId = objects.CurrentUser.id
                Book.currentUserId = objects.CurrentUser.id
            } catch let e {
                print(e)
            }
        }
        task.resume()
        Thread.sleep(forTimeInterval: 0.2)
        return tradingData
    }
    
    static func finishTrade(buyId: Int) -> String {
        var errorText: String = ""
        let url = Api.host + Api.Books.Book.finishTrade(buyId: buyId).path()
        let type = Api.RequestType.DELETE.rawValue
        let request = Api.makeRequest(url: url, status: type)
        let params: [String:String?] = ["id": "\(buyId)"]
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = jsonData
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: request as URLRequest, completionHandler: { (respData, resp, error) -> Void in
                if respData != nil {
                    errorText = String(data: respData!, encoding: .utf8)!
                }
            })
            task.resume()
            Thread.sleep(forTimeInterval: 0.2)
        }catch{
            errorText = error.localizedDescription
        }
        return errorText
    }
}