//
//  CreateTaskViewModel.swift
//  TaskShare
//
//  Created by 鈴木友也 on 2019/09/27.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import FirebaseAuth
import Foundation
import RxCocoa
import RxSwift

final class CreateTaskViewModel {
    let firebaseActionModel: FirebaseActionModel!
    private var user = Auth.auth().currentUser
    
    var tasks: [TaskModel] = []
    
    var titleText: String = ""
    var descriptionText: String = ""
    var timeText: String = ""
    var locationText: String = ""
    
    private let disposeBag = DisposeBag()
    
    init(firebaseActionModel: FirebaseActionModel) {
        self.firebaseActionModel = firebaseActionModel
    }
    
    struct Input {
        let viewWillAppear: Driver<Void>
        let titleText: BehaviorRelay<String>
        let descriptionText: BehaviorRelay<String>
        let timeText: BehaviorRelay<String>
        let locationText: BehaviorRelay<String>
        let createButtonTapped: Driver<Void>
    }
    
    struct Output {
        let dismissViewController: Driver<Void>
    }
    
    func build(input: Input) -> Output {
        input.viewWillAppear
            .asObservable()
            .subscribe(onNext: { _ in
                self.firebaseActionModel
                    .updateTask()
                    .map { [unowned self] snap in
                        self.firebaseActionModel.handleTaskSnapshot(snap: snap) { tasks in
                            self.tasks = tasks
                        }
                    }
                
            })
            .disposed(by: disposeBag)
        
        input.titleText
            .subscribe(onNext: { title in
                self.titleText = title
            })
            .disposed(by: disposeBag)
        
        input.descriptionText
            .subscribe(onNext: { description in
                self.descriptionText = description
            })
            .disposed(by: disposeBag)
        
        input.timeText
            .subscribe(onNext: { time in
                self.timeText = time
            })
            .disposed(by: disposeBag)
        
        input.locationText
            .subscribe(onNext: { location in
                self.locationText = location
            })
            .disposed(by: disposeBag)
        
        let task = input.createButtonTapped
            .asObservable()
            .map { [unowned self] _ -> TaskModel in
                TaskModel(title: self.titleText,
                          description: self.descriptionText,
                          createdAt: Date().description,
                          createUserName: self.user!.displayName ?? "",
                          assignedUserName: self.user!.displayName ?? "",
                          time: self.timeText,
                          location: self.locationText)
            }
            .flatMap { [unowned self] task in
                self.firebaseActionModel.registerTask(task: task)
            }
            .map { _ in () }
            .asDriver(onErrorDriveWith: Driver.empty())
        
        return Output(dismissViewController: task)
    }
}
