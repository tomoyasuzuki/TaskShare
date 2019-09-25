//
//  FriendTaskViewModel.swift
//  TaskShare
//
//  Created by 鈴木友也 on 2019/09/25.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

final class FriendTaskViewModel {
    let firebaseActionModel: FirebaseActionModel!
    
    var tasks = [TaskModel]()
    var friends = [UserModel]()
    
    init(firebaseActionModel: FirebaseActionModel) {
        self.firebaseActionModel = firebaseActionModel
    }
    
    struct Input {
        let viewWillAppear: Driver<Void>
        let addFriendTaskButtonTapped: Driver<Void>
    }
    
    struct Output {
        let presentViewController: Driver<Void>
        let reloadData: Driver<Void>
    }
    
    func build(input: Input) -> Output {
        let tasks = input.viewWillAppear
            .flatMap { [unowned self] _ in
                self.firebaseActionModel.getFriendTask(id: "xhanE8ajv7U3CXw2oI8Uyva0smN2")
                    .map { [unowned self] snapshot in
                        self.firebaseActionModel.handleSnapshot(snap: snapshot) { tasks in
                            self.tasks = tasks
                            print(self.tasks[0].title)
                        }
                    }
                    .map { _ in () }
                    .asDriver(onErrorDriveWith: Driver.empty())
            }
        
        
        return Output(presentViewController: input.addFriendTaskButtonTapped, reloadData: tasks)
    }
}
