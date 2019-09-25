//
//  MytTaskViewModel.swift
//  TaskShare
//
//  Created by 鈴木友也 on 2019/09/25.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import RxSwift
import RxCocoa
import FirebaseFirestore

final class MyTaskViewModel {
    
    private var firebaseActionModel: FirebaseActionModel!
    
    var tasks = [TaskModel]()
    
    init(firebaseActionModel: FirebaseActionModel) {
        self.firebaseActionModel = firebaseActionModel
    }
    struct Input {
        let addMyTaskButtonTapped: Driver<Void>
        let viewWillAppear: Driver<Void>
    }
    
    struct Output {
        let presentViewController: Driver<Void>
        let reloadData: Driver<Void>
    }
    
    func build(input: Input) -> Output {
        let tasks = input.viewWillAppear
            .flatMap { [unowned self] _ in
                return self.firebaseActionModel
                .updateTask()
                .map { [unowned self] snapshot in
                    self.firebaseActionModel.handleSnapshot(snap: snapshot) { tasks in
                        self.tasks = tasks
                    }
                }
                .map { _ in () }
                .asDriver(onErrorDriveWith: Driver.empty())
            }
        
        
        return Output(presentViewController: input.addMyTaskButtonTapped, reloadData: tasks)
    }
}
