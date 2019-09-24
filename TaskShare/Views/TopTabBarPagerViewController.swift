//
//  TopTabBarPagerViewController.swift
//  TaskShare
//
//  Created by 鈴木友也 on 2019/09/24.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import UIKit
import Foundation
import XLPagerTabStrip

class TopTabBarPagerViewController: ButtonBarPagerTabStripViewController {
    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = UIColor.hex(string: "#4169e1", alpha: 1.0)
        settings.style.buttonBarItemBackgroundColor = UIColor.hex(string: "#4169e1", alpha: 1.0)
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarBackgroundColor = .white
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0.0
        settings.style.buttonBarRightContentInset = 0.0
        settings.style.buttonBarLeftContentInset = 0.0
        
        super.viewDidLoad()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        // ViewControllerをインスタンス化させる
        let myTaskViewController = MyTaskViewController()
        let friendTaskViewCotroller = FriendTaskViewController()
        let friendsViewController = FriendsViewController()
        let searchFriendsViewController = SearchFriendsViewController()
        
        let childViewControllers = [myTaskViewController, friendTaskViewCotroller, friendsViewController, searchFriendsViewController]
           
           return childViewControllers
    }
}
