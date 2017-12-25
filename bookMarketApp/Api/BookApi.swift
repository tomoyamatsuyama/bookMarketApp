//
//  BookApi.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/17.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import Foundation

extension Api {
    struct Books {
        enum Book {
            case bookAll
            case bookDetail
            case postPurchased
            case finishTrade  //(buyId: Int)
            case getTrading
            
            var path: String {
                switch self {
                case .bookAll:
                    return "books.json"
                case .bookDetail:
                    return "books/"
                case .postPurchased:
                    return "rooms.json"
                case .finishTrade:
                    return "buys/"
                case .getTrading:
                    return "rooms.json"
                }
            }
        }
        
        static var currentUserId: Int = 0
        
        static func getAll(completion: ((BooksData) -> Void)? = nil) {
            var booksData: BooksData = BooksData()
            let path = Book.bookAll.path
            guard let request = Api.makeRequest(url: Api.host + path, type: Api.RequestType.GET.rawValue) else { return }
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
                    UserDefaults.standard.set(objects.CurrentUser.id, forKey: Info.User.id.rawValue)
                    UserDefaults.standard.set(objects.CurrentUser.user_name, forKey: Info.User.name.rawValue)
                    DispatchQueue.main.async {  //You must write main queue (View関係はmainで書く)
                        completion?(booksData)
                    }
                } catch let e {
                    print(e)
                }
            }
            task.resume()
        }
        
        static func getBookDetail(bookId: Int, completion: ((BookDetailData) -> Void)? = nil) {
            var bookDetailData: BookDetailData = BookDetailData()
            let path = Book.bookDetail.path + "\(bookId)" + ".json"
            guard let request = Api.makeRequest(url: Api.host + path, type: Api.RequestType.GET.rawValue) else { return }
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
                    DispatchQueue.main.async {
                        completion?(bookDetailData)
                    }
                } catch let e {
                    print(e)
                }
            }
            task.resume()
        }
        
        static func postPurchased(bookName: String, bookId: String, image1: String, completion: (() -> Void)? = nil) {
            let path = Book.postPurchased.path
            guard var request = Api.makeRequest(url: Api.host + path, type: Api.RequestType.POST.rawValue) else { return }
            let params: [String:Any] = ["room":["name":bookName, "book_id": bookId, "image1": image1]]
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
                request.httpBody = jsonData
                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config)
                let task = session.dataTask(with: request as URLRequest, completionHandler: { (respData, resp, error) -> Void in
                    DispatchQueue.main.async {
                        completion?()
                    }
                })
                task.resume()
            }catch{
                print(error.localizedDescription)
            }
        }
        
        static func getTradingData(completion: ((TradingData) -> Void)? = nil) {
            var tradingData = TradingData()
            let path = Book.getTrading.path
            guard let request = Api.makeRequest(url: Api.host + path, type: Api.RequestType.GET.rawValue) else { return }
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
                    
                    DispatchQueue.main.async {
                        completion?(tradingData)
                    }
                } catch let e {
                    print(e)
                }
            }
            task.resume()
        }
        
        static func finishTrade(buyId: Int, completion: ((String) -> Void)? = nil) {
            var errorText: String = ""
            let path = Book.finishTrade.path + "\(buyId)"
            guard var request = Api.makeRequest(url: Api.host + path, type: Api.RequestType.DELETE.rawValue) else { return }
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
                    completion?(errorText)
                })
                task.resume()
            }catch{
                errorText = error.localizedDescription
            }
        }
    }
}
