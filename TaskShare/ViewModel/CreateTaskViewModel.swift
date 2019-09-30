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
    
    private var title: String?
    private var description: String?
    private var time: String?
    private var location: String?
    
    init(firebaseActionModel: FirebaseActionModel) {
        self.firebaseActionModel = firebaseActionModel
    }
    
    struct Input {
        let titleTextSubject: Driver<String>
        let descriptionTextSubject: Driver<String>
        let timeTextSubject: Driver<String>
        let locationTextSubject: Driver<String>
        let createButtonTapped: Driver<Void>
    }
    
    struct Output {
        let dismissViewController: Driver<Void>
    }
    
    func build(input: Input) -> Output {
        // ボタンのイベントが流れると同時に他のイベントのストリームからテキストを取り出す。
        // そのテキストを元にFirebaseに保存する
        // 処理が終わったら通知を出してdismiss
//        input.titleTextSubject
//            .drive(onNext: { [weak self] title in
//                guard let self = self else { return }
//                self.title = title
//            })
//            .disposed(by: disposeBag)
//
//        input.descriptionTextSubject
//            .drive(onNext: { [weak self] description in
//                guard let self = self else { return }
//                self.description = description
//            })
//            .disposed(by: disposeBag)
//
//        input.timeTextSubject
//            .drive(onNext: { [weak self] time in
//                guard let self = self else { return }
//                self.time = time
//            })
//            .disposed(by: disposeBag)
//
//        input.locationTextSubject
//            .drive(onNext: { [weak self] location in
//                guard let self = self else { return }
//                self.location = location
//            })
//            .disposed(by: disposeBag)
        
//        let register = input.createButtonTapped
//            .flatMap { [unowned self] _ -> Driver<Void> in
//                self.firebaseActionModel
//                    .registerTask(task: TaskModel(title: self.title!, description: self.description!, createdAt: Date().toFormattedString(), createUserName: self.user!.displayName!, assignedUserName: self.user!.displayName!, time: self.time!, location: self.location!))
//                    .map { _ in () }
//                    .asDriver(onErrorDriveWith: Driver.empty())
//            }
        
//        return Output(dismissViewController: register)
    }
}
