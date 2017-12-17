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
        let path = Api.Users.User.signIn.path()
        guard let url = URL(string: Api.host + path) else { return "" }
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = Api.RequestType.POST.rawValue
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
    
    // Swift GCD Dispatch.main.async ....
    
//    class Test {
//        func main() {
////            let comp: ((String?) -> Void)?
////
////            comp = { text in
////
////            }
////
////            Users.register(email: "", completion: comp)
//
////            let comp2 = { (item: String?) in
////
////            }
////
////            Users.register(email: "", completion: comp2)
//
//            Users.register(email: "", completion: { text in
//                guard let text = text else { return }
//            })
//        }
//    }
    
//    static func register(email: String, completion: ((String?)->Void)? = nil) {
//        do {
////            let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
////            request.httpBody = jsonData
//            let config = URLSessionConfiguration.default
//            let session = URLSession(configuration: config)
//            let task = session.dataTask(with: request as URLRequest, completionHandler: { (respData, resp, error) -> Void in
//                if respData != nil {
//                    let text = String(data: respData!, encoding: .utf8)
//                    errorText = text!
//                    completion?(text)
//                } else {
//
//                }
//            })
//            task.resume()
////            Thread.sleep(forTimeInterval: 0.2)
//        } catch {
////            errorText = error.localizedDescription
//        }
//    }
    
    static func resister(_ email: String, _ password: String, _ password_confirmation: String, _ user_name: String) -> String {
        var errorText: String = ""
        let path = Api.Users.User.resister.path()
        guard let url = URL(string: Api.host + path) else { return "" }
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = Api.RequestType.POST.rawValue
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
        let url = Api.Users.User.getProfile(bookId: Book.currentUserId).path()
        let request = Api.getRequet(url: url)
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
    
    static func edit(_ mail: String, _ pass: String, _ confirmPass: String, _ currentPass: String, _ name: String) -> String{
        var errorText: String = ""
        let url = Api.Users.User.edit.path()
        let type = Api.RequestType.PUT.rawValue
        let request = Api.makeRequest(url: Api.host + url, status: type)
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
        let url = Api.Users.User.signOut.path()
        let type = Api.RequestType.DELETE.rawValue
        let request = Api.makeRequest(url: Api.host + url, status: type)
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
