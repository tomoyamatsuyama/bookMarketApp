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
    
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var inputMailAddress: UITextField!
    @IBOutlet var inputPass: UITextField!
    @IBOutlet var inputConfirmPass: UITextField!
    @IBOutlet var inputUserName: UITextField!
    
    @IBAction func resisterButton(sender: AnyObject) {
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
//            nextPage()
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
