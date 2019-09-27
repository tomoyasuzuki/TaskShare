//
//  FriendsViewController.swift
//  TaskShare
//
//  Created by 鈴木友也 on 2019/09/24.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift
import RxCocoa

class FriendsViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private var viewModel: FriendsViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FriendsTableViewCell")
        
        view.addSubview(tableView)
        
        configureViewModel()
        configureConstraints()
    }
}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell", for: indexPath)
        cell.textLabel?.text = viewModel.friends[indexPath.row].name
        return cell
    }
}

extension FriendsViewController {
    private func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    private func configureViewModel() {
        viewModel = FriendsViewModel(firebaseActionModel: FirebaseActionModel())
        
        let input = FriendsViewModel.Input(viewWillAppear: rx.viewWillAppear.asDriver())
        let output = viewModel.buid(input: input)
        
        output
        .reloadData
            .drive(onNext: { _ in
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}


extension FriendsViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        "Friends"
    }
}
