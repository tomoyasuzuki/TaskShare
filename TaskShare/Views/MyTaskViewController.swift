//
//  MyTaskViewController.swift
//  TaskShare
//
//  Created by 鈴木友也 on 2019/09/24.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import UIKit
import SnapKit
import XLPagerTabStrip

class MyTaskViewController: UIViewController {
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        return containerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension MyTaskViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        "MyTask"
    }
}
