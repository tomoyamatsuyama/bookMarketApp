//
//  UserApi.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/17.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import Foundation

extension Api {
    
    struct Users {
        
        enum User {
            case signIn
            case signOut
            case edit
            case resister
            case getProfile
            
            var path: String {
                switch self {
                case .resister:
                    return "users.json"
                case .edit:
                    return "users.json"
                case .signIn:
                    return "users/sign_in.json"
                case .signOut:
                    return "users/sign_out.json"
                case .getProfile:
                    return "users/"
                }
            }
        }
        
        static func singnIn(email: String, password: String, completion: ((Bool) -> Void)? = nil) {
            guard let url = URL(string: Api.host + User.signIn.path) else { return }
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
                let task = session.dataTask(with: request as URLRequest, completionHandler: { (respData, response, error) -> Void in
                    guard let responseData = respData else { return }
                    do{
                        let dic = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                        guard let dictionary = dic else { return }
                        guard let auth = dictionary["authentication_token"] else { return }
                        print(dic)
                        UserDefaults.standard.set(auth, forKey: Info.User.auth.rawValue)
                        UserDefaults.standard.set(email, forKey: Info.User.email.rawValue)
                    } catch {
                        print("error")
                    }
                    guard let response = response else { return }
                    let isStatus = Api.checkResponse(response: response)
                    DispatchQueue.main.async {
                        completion?(isStatus)
                    }
                })
                task.resume()
            }catch{
                print(error.localizedDescription)
            }
        }
        
        static func resister(email: String, password: String, password_confirmation: String, user_name: String, completion: ((Bool) -> Void)? = nil) {
            guard let url = URL(string: Api.host + User.resister.path) else { return  }
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
                    guard let response = resp else { return }
                    let isStatus = Api.checkResponse(response: response)
                    DispatchQueue.main.async {
                        completion?(isStatus)
                    }
                })
                task.resume()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        static func getProfileData(completion: ((ProfileData) -> Void)? = nil) {
            var profileData: ProfileData = ProfileData()
            guard let userId = UserDefaults.standard.string(forKey: Info.User.id.rawValue) else { return }
            let path = User.getProfile.path + userId + ".json"
            guard let request = Api.makeRequest(url: Api.host + path, type: Api.RequestType.GET.rawValue) else { return }
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
                    DispatchQueue.main.async {
                        completion?(profileData)
                    }
                } catch let e {
                    print(e)
                }
                
            }
            task.resume()
        }
        
        static func edit(parameter: [String:String], completion: ((Bool) -> Void)? = nil) {
            guard var request = Api.makeRequest(url: Api.host + User.edit.path, type: Api.RequestType.PUT.rawValue) else { return }
            // TODO: you can reduce parameters with backend engineer
            let params = ["user": parameter]
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
                request.httpBody = jsonData
                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config)
                let task = session.dataTask(with: request, completionHandler: { (respData, resp, error) -> Void in
                    guard let responseData = respData else { return }
                    guard let response = resp else { return }
                    let isStatus = Api.checkResponse(response: response)
                    DispatchQueue.main.async {
                        completion?(isStatus)
                    }
                    do{
                        let dic = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                        guard let dictionary = dic else { return }
                        guard let auth = dictionary["authentication_token"] else { return }
                        UserDefaults.standard.set(auth, forKey: Info.User.auth.rawValue)
                    } catch {
                        print("error")
                    }
                })
                task.resume()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        static func signOut(completion: ((Bool) -> Void)? = nil) {
            guard var request = Api.makeRequest(url: Api.host + User.signOut.path, type: Api.RequestType.DELETE.rawValue) else { return }
            let params: [String:String?] = ["authenticity_token": nil]
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
                request.httpBody = jsonData
                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config)
                let task = session.dataTask(with: request, completionHandler: { (respData, resp, error) -> Void in
                    guard let response = resp else { return }
                    let isStatus = Api.checkResponse(response: response)
                    completion?(isStatus)
                })
                
                if let appDomain = Bundle.main.bundleIdentifier {
                    UserDefaults.standard.removePersistentDomain(forName: appDomain)
                }
                task.resume()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
