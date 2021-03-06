//
//  CommentViewController.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/11.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {
    @IBOutlet private weak var commentScrollView: UIScrollView!
    @IBOutlet private weak var commentTableView: UITableView!
    @IBOutlet private weak var inputComment: UITextField!
    
    private var commentViewModel = CommentViewModel()
    private let refreshControl = UIRefreshControl()
    
    static func instantiate(roomId: Int, bookId: Int) -> CommentViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Comment", bundle: nil)
        let commentView: CommentViewController = storyboard.instantiateInitialViewController() as! CommentViewController
        commentView.commentViewModel.initialize(roomId: roomId, bookId: bookId)
        return commentView
    }
    
    @IBAction func touchGesture(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func sendCommentButton(_ sender: Any) {
        if let comment = inputComment.text {
            Api.Comments.postComment(commentId: String(commentViewModel.currentRoomId), comment: comment, currentUserId: commentViewModel.commentData.currentUserId, completion: { isStatus in
                if isStatus == false {
                    return
                } else if isStatus == true {
                    self.inputComment.text = ""
                    self.reloadComment()
                }
            })
        }
    }
    
    private func reloadComment(){
        commentViewModel.getCommentData(completion: { [weak self] in
            guard let `self` = self else { return }
            self.commentTableView.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentViewModel.getCommentData(completion: { [weak self] in
            guard let `self` = self else { return }
            self.commentTableView.reloadData()
        })
        commentScrollView.isPagingEnabled = true
        commentTableView.dataSource = commentViewModel
        commentTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refreshControlValueChanged(sender:)), for: .valueChanged)
    }
    
    @objc private func refreshControlValueChanged(sender: UIRefreshControl) {
        reloadComment()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            sender.endRefreshing()
        })
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
