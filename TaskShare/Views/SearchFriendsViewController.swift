//
//  SearchFriendsViewController.swift
//  TaskShare
//
//  Created by 鈴木友也 on 2019/09/24.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift
import RxCocoa

class SearchFriendsViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private var viewModel: SearchFriendsViewModel!
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

extension SearchFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.allUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell", for: indexPath)
        cell.textLabel?.text = viewModel.allUser[indexPath.row].name
        return cell
    }
}

extension SearchFriendsViewController {
    private func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    private func configureViewModel() {
        viewModel = SearchFriendsViewModel(firebaseActionModel: FirebaseActionModel())
        
        let input = SearchFriendsViewModel.Input(viewWillAppear: rx.viewWillAppear.asDriver())
        let output = viewModel.bulid(input: input)
        
        output
        .reloadData
            .drive(onNext: { _ in
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension SearchFriendsViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        "Search"
    }
}

