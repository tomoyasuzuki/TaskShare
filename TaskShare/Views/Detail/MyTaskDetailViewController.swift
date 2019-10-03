//
//  MyTaskDetailViewController.swift
//  TaskShare
//
//  Created by 鈴木友也 on 2019/10/02.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyTaskDetailViewController: TaskDetailViewController {
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hex(string: "#4169e1", alpha: 1.0)
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "leftbackicon"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(dismissDetail), for: .touchUpInside)
        return button
    }()
    
    private lazy var naviTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.textColor = .white
        return label
    }()
    
    private var viewModel: MyTaskDetailViewModel!
    private var taskRelay =  PublishRelay<TaskModel>()
    private var task: TaskModel!
    private let disposeBag = DisposeBag()
    
    init(task: TaskModel) {
        super.init(nibName: nil, bundle: nil)
        self.task = task
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(headerView)
        view.addSubview(backButton)
        view.addSubview(naviTitleLabel)
        
        configureViewModel()
        configureAdditionalConstraints()
        taskRelay.accept(task)
    }
    
    @objc func dismissDetail() {
        self.dismiss(animated: true, completion: nil)
    }
}


extension MyTaskDetailViewController {
    private func configureViewModel() {
        viewModel = MyTaskDetailViewModel()
        
        let input = MyTaskDetailViewModel.Input(task: taskRelay)
        
        let output = viewModel.build(input: input)
        
        output
        .task
            .drive(onNext: { [weak self] task in
                guard let self = self else { return }
                
                self.titleLabel.text = "Title: " + task.title
                self.descriptionLabel.text = "Description: " + task.description
                self.timeLabel.text = "Time: " + task.time
                self.locationLabel.text = "Location: " + task.location
            })
            .disposed(by: disposeBag)
    }
}

extension MyTaskDetailViewController {
    func configureAdditionalConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view)
            make.height.equalTo(80)
        }
        
        backButton.snp.makeConstraints { make in
            make.left.equalTo(view)
            make.centerY.equalTo(headerView)
            make.height.width.equalTo(40)
        }
        
        naviTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(headerView)
            make.centerX.equalTo(headerView)
        }
    }
}
