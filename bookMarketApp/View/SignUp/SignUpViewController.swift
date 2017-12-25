//
//  SignUpViewController.swift
//  
//
//  Created by 松山友也 on 2017/12/10.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBAction func touchGesture(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    @IBOutlet private var errorLabel: UILabel!
    @IBOutlet private var inputMailAddress: UITextField!
    @IBOutlet private var inputPass: UITextField!
    @IBOutlet private var inputConfirmPass: UITextField!
    @IBOutlet private var inputUserName: UITextField!
    
    @IBAction private func resisterButton(sender: AnyObject) {
        guard let mailAddress = inputMailAddress.text else { return }
        guard let pass = inputPass.text else { return }
        guard let confirmPass = inputConfirmPass.text else { return }
        guard let userName = inputUserName.text else { return }
        Api.Users.resister(email: mailAddress, password: pass, password_confirmation: confirmPass, user_name: userName, completion: { errorText in
            if errorText.contains("error") {
                self.errorCheck(isError: true)
            } else {
                self.errorCheck(isError: false)
            }
        })
    }
    
    private func errorCheck(isError: Bool) {
        switch isError {
        case true:
            self.errorLabel.text = "正確な値を入力してください"
        default:
            self.errorLabel.text = "登録完了。\n戻ってログインしてください。"
            self.errorLabel.numberOfLines = 0
            self.errorLabel.textColor = UIColor.blue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputMailAddress.placeholder = "g0000000@cc.kyoto-su.ac.jp"
        inputPass.placeholder = "パスワード"
        inputConfirmPass.placeholder = "確認用パスワード"
        inputUserName.placeholder = "ユーザ名"
        
//        let pageViewController = UIPageViewController()
//        pageViewController.view.subviews.map{ $0 as? UIScrollView }.first??.delegate = self
//        pageViewController.view.subviews.flatMap{ $0 as? UIScrollView }.first?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//extension SignUpViewController: UIScrollViewDelegate {
//    
//}

