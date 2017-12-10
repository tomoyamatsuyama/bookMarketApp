//
//  SignIn.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/10.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import Foundation

class Users{
    static func singnIn(_ email: String, _ password: String) -> String {
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
}
