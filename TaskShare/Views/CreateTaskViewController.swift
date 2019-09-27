//
//  CreateTaskViewController.swift
//  TaskShare
//
//  Created by 鈴木友也 on 2019/09/25.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import UIKit
import SnapKit

class CreateTaskViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Create MyTask"
        navigationController?.navigationBar.backgroundColor = UIColor.hex(string: "#4169e1", alpha: 1.0)
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

        // Do any additional setup after loading the view.
        view.backgroundColor = .orange
    }
    
    
}
