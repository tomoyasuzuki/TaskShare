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
    
    var titleTextSubject = BehaviorSubject<String>(value: "")
    var descriptionTextSubject = BehaviorSubject<String>(value: "")
    var timeTextSubject = BehaviorSubject<String>(value: "")
    var locationTextSubject = BehaviorSubject<String>(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Create MyTask"
        navigationController?.navigationBar.backgroundColor = UIColor.hex(string: "#4169e1", alpha: 1.0)
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .orange
        
        configureViewModel()
        configureConstraints()
    }
}

extension CreateTaskViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateTaskTableViewCell", for: indexPath) as! TextFieldTableViewCell
        cell.inputTextField.delegate = self
        cell.inputTextField.tag = indexPath.row
        return cell
    }
}

extension CreateTaskViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        switch textField.tag {
        case 0:
            titleTextSubject.onNext(text)
        case 1:
            descriptionTextSubject.onNext(text)
        case 2:
            timeTextSubject.onNext(text)
        case 3:
            locationTextSubject.onNext(text)
        default:
            return
        }
    }
}

extension CreateTaskViewController {
    func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    func configureViewModel() {
        viewModel = CreateTaskViewModel(firebaseActionModel: FirebaseActionModel())
        
        let input = CreateTaskViewModel
            .Input(titleTextSubject: titleTextSubject.asDriver(onErrorDriveWith: Driver.empty()),
                                              descriptionTextSubject: descriptionTextSubject.asDriver(onErrorDriveWith: Driver.empty()), timeTextSubject: timeTextSubject.asDriver(onErrorDriveWith: Driver.empty()), locationTextSubject: locationTextSubject.asDriver(onErrorDriveWith: Driver.empty()), createButtonTapped: createButton.rx.tap.asDriver())
        let output = viewModel.build(input: input)
        
        
        output
        .dismissViewController
            .drive(onNext: { _ in
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
