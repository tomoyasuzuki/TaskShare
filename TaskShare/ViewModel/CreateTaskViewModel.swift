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
    
    private let disposeBag = DisposeBag()
    
    init(firebaseActionModel: FirebaseActionModel) {
        self.firebaseActionModel = firebaseActionModel
    }
    
    struct Input {
        let titleTextSubject: PublishSubject<String>
        let descriptionTextSubject: PublishSubject<String>
        let timeTextSubject: PublishSubject<String>
        let locationTextSubject: PublishSubject<String>
        let createButtonTapped: Driver<Void>
    }
    
    struct Output {
        let dismissViewController: Driver<Void>
    }
    
    func build(input: Input) -> Output {
        let task = Driver
            .zip(input.titleTextSubject.asDriver(onErrorJustReturn: ""),
                 input.descriptionTextSubject.asDriver(onErrorJustReturn: ""),
                 input.timeTextSubject.asDriver(onErrorJustReturn: ""),
                 input.locationTextSubject.asDriver(onErrorJustReturn: ""),
                 input.createButtonTapped)
            .map { title, desc, time, loca, _ in
                return TaskModel(title: title, description: desc, createdAt: Date().description, createUserName: "dummyName", assignedUserName: "dummyName", time: time, location: loca)
            }
            .flatMap { (task) in
                self.firebaseActionModel.registerTask(task: task)
                    .map { _ in () }
                    .asDriver(onErrorDriveWith: Driver.empty())
            }

        
        return Output(dismissViewController: task)
    }
}
