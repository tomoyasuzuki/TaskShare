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
        
        configureViewModel()
        taskRelay.accept(task)
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
                
                self.titleLabel.text = task.title
                self.descriptionLabel.text = task.description
                self.timeLabel.text = task.time
                self.locationLabel.text = task.location
            })
            .disposed(by: disposeBag)
    }
}
