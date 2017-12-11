//
//  Api.swift
//  
//
//  Created by 松山友也 on 2017/12/10.
//

import Foundation
import UIKit

class Api{
    static func getRequet(url: String) -> URLRequest{
        guard let url = URL(string: url) else { return URLRequest(url: URL(string: "")!) }
        var request = URLRequest(url: url)
        guard let authUrl = URL(string: "http://localhost:3000/users/sign_in.json") else { return request }
        let cookies = HTTPCookieStorage.shared.cookies(for: authUrl as URL)
        let header: [String : String]  = HTTPCookie.requestHeaderFields(with: cookies!)
        request.allHTTPHeaderFields = header
        return request
    }
    
    static func makeRequest(url: String, status: String = "POST") -> NSMutableURLRequest{
        guard let url = URL(string: url) else { return NSMutableURLRequest() }
        guard let authUrl = URL(string: "http://localhost:3000/users/sign_in.json") else { return NSMutableURLRequest() }
        let cookies = HTTPCookieStorage.shared.cookies(for: authUrl as URL)
        let header: [String : String]  = HTTPCookie.requestHeaderFields(with: cookies!)
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = status
        request.setValue(header["Cookie"], forHTTPHeaderField: "Cookie")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
