//
//  FriendTaskViewController.swift
//  TaskShare
//
//  Created by 鈴木友也 on 2019/09/24.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift
import RxCocoa

class FriendTaskViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    private lazy var addFriendTaskButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor.hex(string: "#4169e1", alpha: 1.0)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 60 / 2
        
        return button
    }()
    
    private var viewModel: FriendTaskViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.register(DefaultTableViewCell.self, forCellReuseIdentifier: "myTaskTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        view.addSubview(addFriendTaskButton)
        
        
        configureConstraints()
        configureViewModel()
    }
}

extension FriendTaskViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

extension FriendTaskViewController {
    private func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.right.left.bottom.equalTo(view)
        }
        
        addFriendTaskButton.snp.makeConstraints { make in
            make.bottom.equalTo(view).offset(-16)
            make.right.equalTo(view).offset(-16)
            make.width.height.equalTo(60)
        }
    }
}

extension FriendTaskViewController {
    private func configureViewModel() {
        viewModel = FriendTaskViewModel(firebaseActionModel: FirebaseActionModel())
        
        let input = FriendTaskViewModel.Input(loadView: rx.loadView.asDriver(),
                                              viewWillAppear: rx.viewWillAppear.asDriver(),
                                              addFriendTaskButtonTapped: addFriendTaskButton.rx.tap.asDriver())
        
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
                self.present(CreateTaskViewController(), animated: true, completion: nil)
            })
        .disposed(by: disposeBag)
    }
}

extension FriendTaskViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        "FriendTask"
    }
}
