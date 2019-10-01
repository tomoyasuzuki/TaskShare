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
import RxSwift
import RxCocoa

class MyTaskViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    private lazy var addMyTaskButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor.hex(string: "#4169e1", alpha: 1.0)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 60 / 2
        
        return button
    }()
    
    private var viewModel: MyTaskViewModel!
    private let disposeBag = DisposeBag()
    
    let mocktask = TaskModel(title: "Go to Shool", description: "Please go to school", createdAt: Date().toFormattedString(), createUserName: "tomoya", assignedUserName: "tomoya1", time: Date.init(timeIntervalSinceNow: 60).toFormattedString(), location: "東京都新宿区戸塚1-1-1 早稲田大学")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(DefaultTableViewCell.self, forCellReuseIdentifier: "myTaskTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        view.addSubview(addMyTaskButton)
        
        
        configureConstraints()
        configureViewModel()
    }
}

extension MyTaskViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(viewModel.tasks.count)
        return viewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myTaskTableViewCell", for: indexPath) as! DefaultTableViewCell
        cell.build(task: viewModel.tasks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DefaultTableViewCell.height
    }
}

extension MyTaskViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        "MyTask"
    }
}

extension MyTaskViewController {
    private func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.right.left.bottom.equalTo(view)
        }
        
        addMyTaskButton.snp.makeConstraints { make in
            make.bottom.equalTo(view).offset(-16)
            make.right.equalTo(view).offset(-16)
            make.width.height.equalTo(60)
        }
    }
    
    private func configureViewModel() {
        viewModel = MyTaskViewModel(firebaseActionModel: FirebaseActionModel())
        
        let input = MyTaskViewModel.Input(addMyTaskButtonTapped: addMyTaskButton.rx.tap.asDriver(),
                                          viewWillAppear: rx.viewWillAppear.asDriver())
        let output = viewModel.build(input: input)
        
        output
            .reloadData
            .drive(onNext: { _ in
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output
        .presentViewController
            .drive(onNext: { _ in
                let createVC = CreateTaskViewController()
                let naviVC = UINavigationController(rootViewController: createVC)
                self.present(naviVC, animated: true, completion: nil)
            })
        .disposed(by: disposeBag)
    }
}
