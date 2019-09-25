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
        }
        
    }
}
