//
//  Api.swift
//  
//
//  Created by 松山友也 on 2017/12/10.
//

import Foundation
import UIKit

class Api {
    enum RequestType: String {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
        case DELETE = "DELETE"
    }
    
    static func checkResponse(response: URLResponse) -> Bool {
        guard let httpResponse = response as? HTTPURLResponse else { return false }
        print(httpResponse.statusCode)
        if 200 <= httpResponse.statusCode || httpResponse.statusCode < 300{
            return true
        } else {
            return false
        }
    }
    
    static var host: String {
        return "http://localhost:3000/"
    }
    
    static func makeRequest(url: String, type: String) -> URLRequest? {
        guard let url = URL(string: url) else { return nil }
        var request = URLRequest(url: url)
        guard let auth = UserDefaults.standard.string(forKey: Info.User.auth.rawValue) else { return nil }
        request.httpMethod = type
        request.setValue(auth, forHTTPHeaderField: "authenticity_token")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

