//
//  TopViewController.swift
//  TaskShare
//
//  Created by 鈴木友也 on 2019/09/24.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import UIKit
import Foundation
import XLPagerTabStrip
import FirebaseAuth

class TopViewController: TopTabBarPagerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().signIn(withEmail: "tomoya.s0121@icloud.com", password: "tomoya0121") { _, error in
            guard error == nil else {
                print("error: \(error!.localizedDescription)")
                return
            }
            
            let mocktask = TaskModel(title: "Go to Shool", description: "Please go to school", createdAt: Date().toFormattedString(), createUserName: "tomoya", assignedUserName: "tomoya1", time: Date.init(timeIntervalSinceNow: 60).toFormattedString(), location: "東京都新宿区戸塚1-1-1 早稲田大学")
            
            let fire = FirebaseActionModel()
            fire.registerFriendTask(id: "xhanE8ajv7U3CXw2oI8Uyva0smN2", task: mocktask)
            
        }
        
    }
}
