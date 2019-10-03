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
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private var viewModel: SearchFriendsViewModel!
    private let disposeBag = DisposeBag()
    
    private var cellButtonTapped = PublishRelay<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: "FriendsTableViewCell")
        
        searchTextField.placeholder = "Search"
        searchTextField.layer.borderColor = UIColor.lightGray.cgColor
        searchTextField.layer.borderWidth = 1.0
        searchTextField.layer.cornerRadius = 8.0
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        searchTextField.leftView = paddingView
        searchTextField.leftViewMode = .always
        
        searchButton.setTitle("Search", for: .normal)
        searchButton.titleLabel?.textColor = .white
        searchButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        searchButton.contentEdgeInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
        searchButton.backgroundColor = UIColor.hex(string: "#4169e1", alpha: 1.0)
        searchButton.layer.cornerRadius = 8.0
        searchButton.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        
        view.addSubview(tableView)
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        
        configureViewModel()
        configureConstraints()
    }
}

extension SearchFriendsViewController: UITableViewDelegate, UITableViewDataSource, ButtonTableViewCellDelegate {
    func buttonTapped(cell: Int) {
        self.cellButtonTapped.accept((cell))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell", for: indexPath) as! ButtonTableViewCell
        cell.configureDataSource(user: viewModel.users[indexPath.row])
        cell.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    @objc func dismissKeyboard() {
        searchTextField.endEditing(true)
    }
}

extension SearchFriendsViewController {
    private func configureConstraints() {
        searchTextField.snp.makeConstraints { make in
            make.top.left.equalTo(view).offset(8)
            make.right.equalTo(searchButton.snp.left).offset(-8)
            make.height.equalTo(40)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(searchTextField)
            make.bottom.equalTo(searchTextField)
            make.right.equalTo(view).offset(-8)
            make.width.equalTo(80)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom)
            make.left.right.bottom.equalTo(view)
        }
    }
    
    private func configureViewModel() {
        viewModel = SearchFriendsViewModel(firebaseActionModel: FirebaseActionModel())
        
        let input = SearchFriendsViewModel.Input(searchText: searchTextField.rx.text.orEmpty.asObservable(), searchButtonTapped: searchButton.rx.tap.asDriver(), cellButtonTapped: cellButtonTapped)
        let output = viewModel.bulid(input: input)
        
        output
        .reloadData
            .drive(onNext: { _ in
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}


extension SearchFriendsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension SearchFriendsViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        "Search"
    }
}

