//
//  CommentViewModel.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/12.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//
import UIKit
import Foundation

class CommentViewModel: NSObject, UITableViewDataSource {
    public private(set) var commentData: CommentData = CommentData()
    public private(set) var currentRoomId = 0
    public private(set) var currentBookId = 0
    
    func initialize(roomId: Int, bookId: Int) {
        self.currentRoomId = roomId
        self.currentBookId = bookId
    }
    
    func getCommentData(completion: (() -> Void)? = nil){
        Api.Comments.getCommentRoom(commentRoomId: currentRoomId, completion: { comment in
            self.commentData = comment
            completion?()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        cell.textLabel?.text = "\(commentData.userName[indexPath.row]):  \(commentData.content[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentData.userName.count
    }
}


