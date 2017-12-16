//
//  AccountViewController.swift
//  bookMarketApp
//
//  Created by 松山友也 on 2017/12/11.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    @IBOutlet weak private var accountTableView: UITableView!
    private var accountViewModel = AccountViewModel()
    
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
    
    func nextPage(_ cellId: Int){
        switch cellId {
        case CellType.profile.index:
            goToUserProfile()
        case CellType.mySellingLists.index:
            goToMySellingBook()
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
    
    private func goToSignIn(){
        let storyboard: UIStoryboard = UIStoryboard(name: "SignIn", bundle: nil)
        let signInView = storyboard.instantiateInitialViewController() as! UINavigationController
        self.present(signInView, animated: true, completion: nil)
    }
    
    private func goToUserProfile(){
        let storyboard: UIStoryboard = UIStoryboard(name: "UserProfile", bundle: nil)
        let userProfileView = storyboard.instantiateInitialViewController() as! UserProfileViewController
        self.navigationController?.pushViewController(userProfileView, animated: true)
    }
    
    private func goToMySellingBook(){
        let storyboard: UIStoryboard = UIStoryboard(name: "MySellingBook", bundle: nil)
        let mySellingBookView = storyboard.instantiateInitialViewController() as! MySellingBookViewController
        mySellingBookView.instatiate()
        self.navigationController?.pushViewController(mySellingBookView, animated: true)
    }
    
    private func goToMyTradingBook(){
        let storyboard: UIStoryboard = UIStoryboard(name: "MyTradingBook", bundle: nil)
        let myTradingBookView = storyboard.instantiateInitialViewController() as! MyTradingBookViewController
        myTradingBookView.instatiate()
        self.navigationController?.pushViewController(myTradingBookView, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountTableView.dataSource = accountViewModel
    }
}

extension AccountViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        nextPage(indexPath.row)
    }
}
