//
//  SignIn.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/10.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import Foundation

struct Profile: Codable {
    var User: UserInfo
    var Books: [Books]
    struct UserInfo: Codable {
        var id: Int
        var email: String
        var user_name: String
        var created_at: String
        var updated_at: String
    }
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
        var created_at: String
        var updated_at: String
    }
}

struct ProfileData {
    var userId: Int = 0
    var userName: String = ""
    var userEmail: String = ""
    var idLists: [Int] = []
    var authorLists:[String] = []
    var lessonLists: [String] = []
    var moneyLists: [Int] = []
    var nameLists: [String] = []
    var userIdLists: [Int] = []
    var imageLists: [String : Array<String?>] = [:]
    var commentRoomsId: [Int] = []
}

struct Trading: Codable {
    var Room: [Books]
    var CurrentUser: User
    struct Books: Codable {
        var id: Int
        var user_id: Int
        var user_2: Int
        var name: String
        var image1: String
        var book_id: Int
        var created_at: String
        var updated_at: String
        var author: String
        var lesson: String
        var money: Int
        var buy_id: Int
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

struct TradingData {
    var roomIdLists: [Int] = []
    var userFirstIdLists: [Int] = []
    var userSecondIdLists: [Int] = []
    var bookNameLists: [String] = []
    var imageLists: [String] = []
    var bookIdLists: [Int] = []
    var currentUserId: Int = 0
    var authorLists: [String] = []
    var lessonLists: [String] = []
    var moneyLists: [Int] = []
    var buyIdLists: [Int] = []
}
class Users{
    static func singnIn(_ email: String, _ password: String) -> String{
        var errorText: String = ""
        guard let url = URL(string: "http://localhost:3000/users/sign_in.json") else { return "" }
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let params: [String:Any] = ["user":["email": email, "password": password]]
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = jsonData
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: request as URLRequest, completionHandler: { (respData, resp, error) -> Void in
                if respData != nil {
                    let text = String(data: respData!, encoding: .utf8)
                    errorText = text!
                }
                let httpRes: HTTPURLResponse = (resp as? HTTPURLResponse)!
                let cookies:[HTTPCookie] = HTTPCookie.cookies(withResponseHeaderFields: httpRes.allHeaderFields as! [String : String], for: httpRes.url!)
                HTTPCookieStorage.shared.setCookies(cookies, for: resp?.url!, mainDocumentURL: nil)
            })
            task.resume()
            Thread.sleep(forTimeInterval: 0.3)
        }catch{
            errorText = error.localizedDescription
        }
        return errorText
    }
    
    static func resister(_ email: String, _ password: String, _ password_confirmation: String, _ user_name: String) -> String {
        var errorText: String = ""
        guard let url = URL(string: "http://localhost:3000/users.json") else { return "" }
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let params: [String:Any] = ["user":["email": email, "password": password, "password_confirmation": password_confirmation, "user_name": user_name]]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = jsonData
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: request as URLRequest, completionHandler: { (respData, resp, error) -> Void in
                if respData != nil {
                    let text = String(data: respData!, encoding: .utf8)
                    errorText = text!
                }
            })
            task.resume()
            Thread.sleep(forTimeInterval: 0.2)
        } catch {
            errorText = error.localizedDescription
        }
        return errorText
    }
    
    static func getProfileData() -> ProfileData{
        var profileData: ProfileData = ProfileData()
        let request = Api.getRequet(url: "http://localhost:3000/users/\(Book.currentUserId).json")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let objects: Profile = try JSONDecoder().decode(Profile.self, from: data)
                objects.Books.forEach { object in
                    profileData.idLists.append(object.id)
                    profileData.authorLists.append(object.author)
                    profileData.lessonLists.append(object.lesson)
                    profileData.moneyLists.append(object.money)
                    profileData.nameLists.append(object.name)
                    profileData.userIdLists.append(object.user_id)
                    profileData.imageLists["\(object.id)"] = [object.image1.url!, object.image2.url, object.image3.url]
                }
                profileData.userId = objects.User.id
                profileData.userEmail = objects.User.email
                profileData.userName = objects.User.user_name
                Book.currentUserId = objects.User.id
            } catch let e {
                print(e)
            }
        }
        task.resume()
        Thread.sleep(forTimeInterval: 0.2)
        return profileData
    }
    
    static func getTradingData() -> TradingData{
        var tradingData = TradingData()
        let request = Api.getRequet(url: "http://localhost:3000/rooms.json")
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
    
    static func edit(_ mail: String, _ pass: String, _ confirmPass: String, _ currentPass: String, _ name: String) -> String{
        var errorText: String = ""
        let request = Api.makeRequest(url: "http://localhost:3000/users.json", status: "PUT")
        let params: [String:Any] = ["user":["email": mail, "password": pass, "password_confirmation": confirmPass, "current_password": currentPass, "user_name": name]]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = jsonData
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: request as URLRequest, completionHandler: { (respData, resp, error) -> Void in
                if respData != nil {
                    let text = String(data: respData!, encoding: .utf8)
                    errorText = text!
                }
            })
            task.resume()
            Thread.sleep(forTimeInterval: 0.7)
        } catch {
            errorText = error.localizedDescription
        }
        return errorText
    }
    
    static func signOut() -> String {
        var errorText: String = ""
        var check: String
        let request = Api.makeRequest(url: "http://localhost:3000/users/sign_out.json", status: "DELETE")
        let params: [String:String?] = ["authenticity_token": nil]
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = jsonData
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: request as URLRequest, completionHandler: { (respData, resp, error) -> Void in
                if respData != nil {
                    let text = String(data: respData!, encoding: .utf8)
                    errorText = text!
                }
            })
            task.resume()
            Thread.sleep(forTimeInterval: 0.2)
        }catch{
            errorText = error.localizedDescription
        }
        if errorText.contains("error"){
            check = "NG"
        } else {
            check = "OK"
        }
        return check
    }
    
    
}
