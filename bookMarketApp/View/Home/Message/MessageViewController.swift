//
//  MessageViewController.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/11.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var inputMessage: UITextField!
    @IBOutlet weak var messageTableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    private var messageViewModel = MessageViewModel()
    
    static func instantiate(currentBookId: Int, currentMessageRoomId: Int) -> MessageViewController {
        let storyboard = UIStoryboard(name: "Message", bundle: nil)
        let messageView = storyboard.instantiateInitialViewController() as! MessageViewController
        messageView.messageViewModel.initialize(bookId: currentBookId, roomId: currentMessageRoomId)
        return messageView
    }
    
    @IBAction func sendMessageButton(_ sender: Any) {
        guard let message: String = inputMessage.text else { return }
        Api.Messages.postMessage(message: message, roomId: String(messageViewModel.currentMessageRoomId), completion: { isStatus in
            if isStatus == false {
                return
            } else if isStatus == true {
                self.inputMessage.text! = ""
                self.reloadMessage()
            }
        })
    }
    
    private func reloadMessage(){
        messageViewModel.setMessage(completion: { [weak self] in
            guard let `self` = self else { return }
            self.messageTableView.reloadData()
            self.view.endEditing(true)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isPagingEnabled = true
        messageTableView.dataSource = messageViewModel
        reloadMessage()
        messageTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refreshControlValueChanged(sender:)), for: .valueChanged)
    }
    
    @objc private func refreshControlValueChanged(sender: UIRefreshControl) {
        reloadMessage()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            sender.endRefreshing()
        })
    }
    
    @IBAction private func touchGesture(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeShown), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillBeShown(notification: NSNotification) {
        if let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let inset = keyboardFrame.height
            scrollView.contentInset.bottom = inset + 8.0
            scrollView.scrollIndicatorInsets.bottom = inset + 8.0
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        restoreScrollViewSize()
    }
    
    func restoreScrollViewSize() {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension MessageViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
