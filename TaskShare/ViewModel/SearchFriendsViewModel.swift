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
    
    private let currentUser = Auth.auth().currentUser
    
    var allUser = [UserModel]()
    
    init(firebaseActionModel: FirebaseActionModel) {
        self.firebaseActionModel = firebaseActionModel
    }
    
    struct Input {
        let viewWillAppear: Driver<Void>
    }
    
    struct Output {
        let reloadData: Driver<Void>
    }
    
    func bulid(input: Input) -> Output {
        let allUser = input.viewWillAppear
            .flatMap { _ in
                self.firebaseActionModel.getAllUser()
                    .map { snap in
                        self.firebaseActionModel.handleUserSnapshot(snap: snap) { users in
                            self.allUser = users
                            
                            var index = 0
                            
                            self.allUser.forEach { [unowned self] user in
                                guard let currentUser = self.currentUser else {
                                    return
                                }
                                
                                if user.id == currentUser.uid {
                                    self.allUser.remove(at: index)
                                }
                                
                                index = index + 1
                            }
                        }
                    }
                    .map { _ in () }
                    .asDriver(onErrorDriveWith: Driver.empty())
            }
        
        return Output(reloadData: allUser)
    }
}
