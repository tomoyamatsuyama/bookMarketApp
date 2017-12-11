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
        errorCheck(errorText: Users.resister(mailAddress, pass, confirmPass, userName))
    }
    
    private func errorCheck(errorText: String) {
        if errorText.contains("error") {
            self.errorLabel.text = "正確な値を入力してください"
        } else {
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
