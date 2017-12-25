//
//  UserProfileViewController.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/11.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    @IBOutlet weak private var errorLabel: UILabel!
    @IBOutlet weak private var inputEmailAddress: UITextField!
    @IBOutlet weak private var inputPass: UITextField!
    @IBOutlet weak private var inputConfirmPass: UITextField!
    @IBOutlet weak private var inputCurrentPass: UITextField!
    @IBOutlet weak private var inputUserName: UITextField!
    
    private var userProfileViewModel = UserProfileViewModel()
    
    static func instantiate() -> UserProfileViewController {
        let storyboard = UIStoryboard(name: "UserProfile", bundle: nil)
        let userProfileView = storyboard.instantiateInitialViewController() as! UserProfileViewController
        return userProfileView
    }
    
    private func setParameter(mail: String?, pass: String?, confirmPass: String?, currentPass: String?, name: String?) -> [String:String] {
        let params: [String:String?] = ["email": mail, "password": pass, "password_confirmation": confirmPass, "current_password": currentPass, "user_name": name]
        let parameter = params.reduce([String:String]()) { (parameter, element) in
            
            guard let value = element.value else { return parameter }
            var parameter = parameter
            if value == ""{
                return parameter
            } else {
                parameter[element.key] =  value
            }
            return parameter
        }
        
        return parameter
    }
    
    private func reloadProfile() {
        userProfileViewModel.setUserProfile(completion: { [weak self] in
            guard let `self` = self else { return }
            
            self.setData()
        })
    }
    
    @IBAction func editButton(_ sender: Any) {
        let parameter = setParameter(mail: inputEmailAddress.text, pass: inputPass.text, confirmPass: inputConfirmPass.text, currentPass: inputCurrentPass.text, name: inputUserName.text)
        Api.Users.edit(parameter: parameter, completion: { text in
            if text.contains("error"){
                self.errorLabel.text = "不正な値です。"
            } else {
                self.errorLabel.text = "変更完了です。"
                self.errorLabel.textColor = UIColor.blue
                self.reloadProfile()
            }
        })
    }
    
    
    private func setData() {
        guard let email = UserDefaults.standard.string(forKey: Info.User.email.rawValue) else { return }
        guard let name = UserDefaults.standard.string(forKey: Info.User.name.rawValue) else { return }
        self.inputEmailAddress.text = email
        self.inputPass.placeholder = "新しいパスワード(6文字以上)"
        self.inputConfirmPass.placeholder = "パスワード確認"
        self.inputCurrentPass.placeholder = "古いパスワード"
        self.inputUserName.text = name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userProfileViewModel.setUserProfile(completion: { [weak self] in
            guard let `self` = self else { return }
            self.setData()
        })
    }
}
