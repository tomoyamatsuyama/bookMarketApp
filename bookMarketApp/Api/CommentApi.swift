//
//  CommentApi.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/17.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import Foundation

extension Api {
    struct Comments {
        enum Comment {
            case getCommentRoom
            case postComment
            
            var path: String {
                switch self {
                case .getCommentRoom:
                    return "commentrooms/"
                case .postComment:
                    return "comments.json"
                }
            }
        }
        
        static func getCommentRoom(commentRoomId: Int, completion: ((CommentData) -> Void)? = nil) {
            var commentData = CommentData()
            let path = Comment.getCommentRoom.path + "\(commentRoomId)" + ".json"
            guard let request = Api.makeRequest(url: Api.host + path, type: Api.RequestType.GET.rawValue) else { return }
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let objects: CommentInfo = try JSONDecoder().decode(CommentInfo.self, from: data)
                    objects.Comments.forEach { object in
                        commentData.userId.append(object.user_id)
                        commentData.userName.append(object.user_name)
                        commentData.content.append(object.comment)
                    }
                    commentData.currentUserId = objects.CurrentUser.id
                    commentData.roomId = commentRoomId
                    DispatchQueue.main.async {
                        completion?(commentData)
                    }
                } catch let e {
                    print(e)
                }
            }
            
            task.resume()
        }
        
        static func postComment(commentId: String, comment: String, currentUserId: Int, completion: ((Bool) -> Void)? = nil) {
            guard var request = Api.makeRequest(url: Api.host + Comment.postComment.path, type: Api.RequestType.POST.rawValue) else { return }
            let params: [String:Any] = ["comment":["commentroom_id":commentId, "user_id":currentUserId, "comment":"\(comment)"]]
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
                request.httpBody = jsonData
                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config)
                let task = session.dataTask(with: request, completionHandler: { (respData, resp, error) -> Void in
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
    }
}
