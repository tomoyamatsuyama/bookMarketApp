//
//  AccountViewController.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/11.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var accountTableView: UITableView!
    var accountMenuList = ["ユーザ情報編集", "出品一覧", "取引中一覧", "ログアウト"]
    enum CellType: Int {
        case profile
        case mySellingLists
        case myBuyingLists
        case signOut
        var index: Int {
            switch self {
            case .profile:
                return 0
            case .mySellingLists:
                return 1
            case .myBuyingLists:
                return 2
            case .signOut:
                return 3
            }
        }
    }
    
    private func goToSignIn(){
        let storyboard: UIStoryboard = UIStoryboard(name: "SignIn", bundle: nil)
        let signInView = storyboard.instantiateInitialViewController() as! UINavigationController
        self.present(signInView, animated: true, completion: nil)
    }
    
    private func goToUserProfile(_ profileData: ProfileData){
        let storyboard: UIStoryboard = UIStoryboard(name: "UserProfile", bundle: nil)
        let userProfileView = storyboard.instantiateInitialViewController() as! UserProfileViewController
        userProfileView.userProfileData = profileData
        self.navigationController?.pushViewController(userProfileView, animated: true)
    }
    
    private func goToMySellingBook(_ sellingData: ProfileData){
        let storyboard: UIStoryboard = UIStoryboard(name: "MySellingBook", bundle: nil)
        let mySellingBookView = storyboard.instantiateInitialViewController() as! MySellingBookViewController
        mySellingBookView.sellingData = sellingData
        self.navigationController?.pushViewController(mySellingBookView, animated: true)
    }
    
    private func goToMyTradingBook(){
        let storyboard: UIStoryboard = UIStoryboard(name: "MyTradingBook", bundle: nil)
        let myTradingBookView = storyboard.instantiateInitialViewController() as! MyTradingBookViewController
        myTradingBookView.tradingData = Users.getTradingData()
        self.navigationController?.pushViewController(myTradingBookView, animated: true)
    }
    
    
    func nextPage(_ selectCellTextLabelText: String){
        let profileData = Users.getProfileData()
        let CellId: Int = accountMenuList.index(of: selectCellTextLabelText)!
        switch CellId {
        case CellType.profile.index:
            goToUserProfile(profileData)
        case CellType.mySellingLists.index:
            goToMySellingBook(profileData)
        case CellType.myBuyingLists.index:
            goToMyTradingBook()
        case CellType.signOut.index:
            let check = Users.signOut()
            if check == "OK"{
                goToSignIn()
            }
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension AccountViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectCell = tableView.cellForRow(at: indexPath) else { return }
        guard let selectCellTextLabel = selectCell.textLabel else { return }
        guard let selectCellTextLabelText = selectCellTextLabel.text else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        nextPage(selectCellTextLabelText)
    }
}
