//
//  SignInViewController.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/09.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import UIKit
import Foundation

class SignInViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak private var inputMailAddress: UITextField!
    @IBOutlet weak private var inputPassword: UITextField!
    @IBAction func touchGesture(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func signInButton(_ sender: Any) {
        guard let mailAddress = inputMailAddress.text else { return }
        guard let password = inputPassword.text else { return }
        errorCheck(errorText: Users.singnIn(mailAddress, password))
    }
    
    private func errorCheck(errorText: String) {
        if errorText.contains("error") {
            errorLabel.text = "ログイン失敗"
        } else {
            goToHome()
        }
    }
    
    @IBAction private func createButton(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "SignUp", bundle: nil)
        let signUpView: SignUpViewController = storyboard.instantiateInitialViewController() as! SignUpViewController
        self.navigationController?.pushViewController(signUpView, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputMailAddress.placeholder = "登録メールアドレス"
        inputPassword.placeholder = "パスワード"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
