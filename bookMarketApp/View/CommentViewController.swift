//
//  CommentViewController.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/11.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {
    var commentData = CommentData()
    var roomId = 0
    var bookId = 0
    
    @IBOutlet weak var commentScrollView: UIScrollView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var inputComment: UITextField!
    private let refreshControl = UIRefreshControl()
    
    @IBAction func touchGesture(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func sendCommentButton(_ sender: Any) {
        if let comment = inputComment.text {
            CommentRoom.postComment(String(roomId), comment, commentData.currentUserId)
            inputComment.text = ""
            reloadComment()
        }
    }
    
    private func reloadComment(){
        commentData = CommentRoom.getCommentRoom(commentRoomId: roomId)
        commentTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentScrollView.isPagingEnabled = true
        commentTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refreshControlValueChanged(sender:)), for: .valueChanged)
    }
    
    @objc private func refreshControlValueChanged(sender: UIRefreshControl) {
        reloadComment()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            sender.endRefreshing()
        })
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
            commentScrollView.contentInset.bottom = inset + 8.0
            commentScrollView.scrollIndicatorInsets.bottom = inset + 8.0
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        restoreScrollViewSize()
    }
    
    func restoreScrollViewSize() {
        commentScrollView.contentInset = UIEdgeInsets.zero
        commentScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CommentViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
