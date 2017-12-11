//
//  UserProfileViewController.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/11.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    var userProfileData = ProfileData()
    
    @IBOutlet weak private var errorLabel: UILabel!
    @IBOutlet weak private var inputEmailAddress: UITextField!
    @IBOutlet weak private var inputPass: UITextField!
    @IBOutlet weak private var inputConfirmPass: UITextField!
    @IBOutlet weak private var inputCurrentPass: UITextField!
    @IBOutlet weak private var inputUserName: UITextField!
    
    private func errorCheck(_ errorText: String){
        if errorText.contains("error") {
            errorLabel.text = "不正な値です。"
        } else {
            errorLabel.text = "変更完了です。"
            errorLabel.textColor = UIColor.blue
        }
    }
    
    @IBAction func editButton(_ sender: Any) {
        guard let mailAddress = inputEmailAddress.text else { return }
        guard let pass = inputPass.text else { return }
        guard let confirmPass = inputConfirmPass.text else { return }
        guard let currentPass = inputCurrentPass.text else { return }
        guard let userName = inputUserName.text else { return }
        errorCheck(Users.edit(mailAddress, pass, confirmPass, currentPass, userName))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputEmailAddress.text = userProfileData.userEmail
        inputPass.placeholder = "新しいパスワード(6文字以上)"
        inputConfirmPass.placeholder = "パスワード確認"
        inputCurrentPass.placeholder = "古いパスワード"
        inputUserName.text = userProfileData.userName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
