//
//  FriendsViewModel.swift
//  TaskShare
//
//  Created by 鈴木友也 on 2019/09/25.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

final class FriendsViewModel {
    let firebaseActionModel: FirebaseActionModel!
    
    var friends = [UserModel]()
    
    init(firebaseActionModel: FirebaseActionModel) {
        self.firebaseActionModel = firebaseActionModel
        friends.append(UserModel(id: "", name: "tomoya1"))
    }
    
    struct Input {
        let viewWillAppear: Driver<Void>
    }
    
    struct Output {
        let reloadData: Driver<Void>
    }
    
    func buid(input: Input) -> Output {
        let friends = input.viewWillAppear
            .flatMap { _ in
                self.firebaseActionModel.getAllFriends()
                    .map { snap in
//                        self.firebaseActionModel.handleUserSnapshot(snap: snap) { users in
//                            self.friends = users
//                        }
                        
                    }
                    .map { _ in () }
                    .asDriver(onErrorDriveWith: Driver.empty())
            }
        
        return Output(reloadData: friends)
    }
}
