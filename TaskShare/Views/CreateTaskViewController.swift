//
//  CreateTaskViewController.swift
//  TaskShare
//
//  Created by 鈴木友也 on 2019/09/25.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

class CreateTaskViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private var viewModel: CreateTaskViewModel!
    private let disposeBag = DisposeBag()
    
    private var titleTextSubject = PublishSubject<String>()
    private var descriptionTextSubject = PublishSubject<String>()
    private var timeTextSubject = PublishSubject<String>()
    private var locationTextSubject = PublishSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = "Create MyTask"
        navigationController?.navigationBar.backgroundColor = UIColor.hex(string: "#4169e1", alpha: 1.0)
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        view.addSubview(tableView)
        view.addSubview(createButton)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "CreateTaskTableViewCell")
        createButton.setTitle("Create Task", for: .normal)
        createButton.titleLabel?.textColor = .white
        createButton.backgroundColor = .blue
        createButton.layer.cornerRadius = 8.0
        
        configureViewModel()
        configureConstraints()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension CreateTaskViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "title"
        case 1:
            return "desc"
        case 2:
            return "time"
        case 3:
            return "loca"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateTaskTableViewCell", for: indexPath) as! TextFieldTableViewCell
        cell.tag = indexPath.row
        cell.delegate = self
        return cell
    }
}

extension CreateTaskViewController: TextFieldTableViewCellDelegate {
    func bindTextFieldText(cell: TextFieldTableViewCell, string: String) {
        switch cell.tag {
        case 0:
            titleTextSubject.onNext(string)
        case 1:
            descriptionTextSubject.onNext(string)
        case 2:
            timeTextSubject.onNext(string)
        case 3:
            locationTextSubject.onNext(string)
        default:
            break
        }
    }
}

extension CreateTaskViewController {
    func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view).offset(80)
            make.left.right.bottom.equalTo(view)
        }
        
        createButton.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(60)
            make.bottom.equalTo(view).offset(-16)
            make.centerX.equalTo(view)
        }
    }
    
    func configureViewModel() {
        viewModel = CreateTaskViewModel(firebaseActionModel: FirebaseActionModel())
        
        let input = CreateTaskViewModel
            .Input(titleTextSubject: titleTextSubject,
                   descriptionTextSubject: descriptionTextSubject,
                   timeTextSubject: timeTextSubject,
                   locationTextSubject: locationTextSubject,
                   createButtonTapped: createButton.rx.tap.asDriver())
        
        let output = viewModel.build(input: input)
        
        
        output
        .dismissViewController
            .drive(onNext: { _ in
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
