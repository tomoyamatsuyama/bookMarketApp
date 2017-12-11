//
//  MessageViewController.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/11.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    var messageData: MessageData = MessageData()
    var selectedBookId: Int = 0
    var roomId = 0
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var inputMessage: UITextField!
    @IBOutlet weak var messageTableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    @IBAction func sendMessage(_ sender: Any) {
        guard let message: String = inputMessage.text else { return }
        MessageRoom.postMessage(message: message, roomId: String(roomId))
        inputMessage.text! = ""
        reloadMessage()
    }
    
    private func reloadMessage(){
        messageData = MessageRoom.getMessage(messageRoomId: roomId)
        messageTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isPagingEnabled = true
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            scrollView.contentInset.bottom = inset
            scrollView.scrollIndicatorInsets.bottom = inset
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        restoreScrollViewSize()
    }
    
    func restoreScrollViewSize() {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
