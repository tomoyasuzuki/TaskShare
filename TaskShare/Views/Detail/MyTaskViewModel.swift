//
//  MyTaskViewModel.swift
//  TaskShare
//
//  Created by 鈴木友也 on 2019/10/02.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import RxSwift
import RxCocoa

final class MyTaskDetailViewModel {
    
    struct Input {
        let task: PublishRelay<TaskModel>
    }
    
    struct Output {
        let task: Driver<TaskModel>
    }
    
    func build(input: Input) -> Output {
        return Output(task: input.task.asDriver(onErrorDriveWith: Driver.empty()))
    }
}
