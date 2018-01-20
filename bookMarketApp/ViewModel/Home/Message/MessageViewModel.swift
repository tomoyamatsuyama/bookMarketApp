//
//  MessageViewModel.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/12.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//
import UIKit
import Foundation

class MessageViewModel: NSObject, UITableViewDataSource {
    private var messageData: MessageData = MessageData()
    public private(set) var currentMessageRoomId = 0
    
    func initialize(bookId: Int, roomId: Int) {
        self.currentMessageRoomId = roomId
    }
    
    func setMessage(completion: (() -> Void)? = nil) {
        Api.Messages.getMessage(messageRoomId: currentMessageRoomId, completion: { message in
            self.messageData = message
            completion?()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        cell.textLabel?.text = "\(messageData.userNameLists[indexPath.row]):  \(messageData.contentsLists[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageData.userNameLists.count
    }
}

