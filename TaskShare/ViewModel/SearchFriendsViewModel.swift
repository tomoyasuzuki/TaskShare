//
//  SearchViewModel.swift
//  TaskShare
//
//  Created by 鈴木友也 on 2019/09/25.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxSwift
import RxCocoa

final class SearchFriendsViewModel {
    let firebaseActionModel: FirebaseActionModel!
    
    private var text: String = ""
    
    var users = [UserModel]()
    
    private let disposeBag = DisposeBag()
    
    init(firebaseActionModel: FirebaseActionModel) {
        self.firebaseActionModel = firebaseActionModel
    }
    
    struct Input {
        let searchText: Observable<String>
        let searchButtonTapped: Driver<Void>
        let cellButtonTapped: PublishRelay<Int>
    }
    
    struct Output {
        let reloadData: Driver<Void>
    }
    
    func bulid(input: Input) -> Output {
        
        input.cellButtonTapped
            .asObservable()
            .subscribe(onNext: { [unowned self] cell in
                let id = self.users[cell].id
                let name = self.users[cell].name
                
                self.firebaseActionModel.registerFriend(id: id, name: name)
            })
            .disposed(by: disposeBag)
        
        input.searchText
            .subscribe(onNext: { text in
                self.text = text
            })
            .disposed(by: disposeBag)
        
        let result = input.searchButtonTapped
            .asObservable()
            .flatMap {[unowned self] _ in self.firebaseActionModel.searchUser(text: self.text)}
            .map {[unowned self] snap in
                self.firebaseActionModel.handleUserSnapshot(snap: snap) { users in
                    self.users = users
                }}
            .map { _ in ()}
            .asDriver(onErrorDriveWith: Driver.empty())
            
        return Output(reloadData: result)
    }
}
