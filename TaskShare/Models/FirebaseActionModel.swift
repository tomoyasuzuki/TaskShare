//
//  FirebaseActionModel.swift
//  TaskShare
//
//  Created by 鈴木友也 on 2019/09/25.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import RxSwift

protocol FirebaseActionProtocol {
    func login(email: String, password: String) -> Observable<Void>
    func searchUser(text: String) -> Observable<QuerySnapshot>
    func registerUser(name: String) -> Observable<Void>
    func registerFriend(id: String, name: String) -> Void
    func registerTask(task: TaskModel) -> Observable<Void>
    func registerFriendTask(id: String, task: TaskModel) -> Observable<Void>
    func updateTask() -> Observable<QuerySnapshot>
    func getAllMyTasks() -> Observable<QuerySnapshot>
    func getFriendTask(id: String) -> Observable<QuerySnapshot>
    func getAllFriends() -> Observable<QuerySnapshot>
    func getAllFriendsTasks() -> Observable<QuerySnapshot>
    func getAllUser() -> Observable<QuerySnapshot>
}

final class FirebaseActionModel: FirebaseActionProtocol {
    // MARK: Property
    
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    // MARK: Auth Method
    
    func login(email: String, password: String) -> Observable<Void> {
        return Observable.create { observer in
            Auth.auth().signIn(withEmail: email, password: password) { _, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    observer.onError(error!)
                    return
                }
                
                observer.onNext(())
            }
            return Disposables.create()
        }
    }
    
    func searchUser(text: String) -> Observable<QuerySnapshot> {
        return Observable.create { observer in
            self.db
                .collection(StringKey.users)
                .whereField(StringKey.name, isEqualTo: text)
                .addSnapshotListener { snapshot, error in
                    guard error == nil else {
                        print(error!.localizedDescription)
                        observer.onError(error!)
                        return
                    }
                    
                    guard let snapshot = snapshot else {
                        observer.onError(error!)
                        return
                    }
                    
                    observer.onNext(snapshot)
                    print("sent snap")
                }
            
            return Disposables.create()
        }
    }
    
    // MARK: Register Method
    
    func registerUser(name: String) -> Observable<Void> {
        return Observable.create { [unowned self] observer in
            let disposables = Disposables.create()
            
            guard let user = self.user else {
                observer.onError(FireAuthError.unexpected)
                return disposables
            }
            
            self.db.collection(StringKey.users)
                .document(user.uid)
                .setData([StringKey.id: user.uid, StringKey.name: name]) { error in
                    guard error == nil else {
                        print(error!.localizedDescription)
                        observer.onError(error!)
                        return
                    }
                    
                    observer.onNext(())
                }
            
            return disposables
        }
    }
    
    func registerFriend(id: String, name: String) {
        guard let user = self.user else {
            return
        }
        
        guard id != user.uid else { return }
        
        let ref = self.db
            .collection(StringKey.users)
            .document(user.uid)
            .collection(StringKey.friends)
        
        ref.document(id)
            .setData([StringKey.id: id, StringKey.name: name]) { error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
            }
    }
    
    func registerTask(task: TaskModel) -> Observable<Void> {
        return Observable.create { observer  in
            let disposables = Disposables.create()
            
            guard let user = self.user else {
                observer.onError(FireAuthError.unexpected)
                return disposables
            }
            
            let userRef = self.db
                .collection(StringKey.users)
                .document(user.uid)
                .collection(StringKey.tasks)
            
            let taskRef = self.db
                .collection(StringKey.tasks)
            
            userRef.addDocument(data: [StringKey.title: task.title,
                                       StringKey.description: task.description,
                                       StringKey.createdAt: task.createdAt,
                                       StringKey.createUserName: task.createUserName,
                                       StringKey.assignedUserName: task.assignedUserName,
                                       StringKey.time: task.time,
                                       StringKey.location: task.location]) { error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    observer.onError(error!)
                    return
                }
                
                taskRef.addDocument(data: [StringKey.title: task.title,
                                           StringKey.description: task.description,
                                           StringKey.createdAt: task.createdAt,
                                           StringKey.time: task.time,
                                           StringKey.location: task.location,
                                           StringKey.assignedUserRef: self.db.collection(StringKey.users).document(user.uid),
                                           StringKey.createUserRef: self.db.collection(StringKey.users).document(user.uid)]) { error in
                    
                    guard error == nil else {
                        print(error!.localizedDescription)
                        observer.onError(error!)
                        return
                    }
                }
            }
            return disposables
        }
    }
    
    func registerFriendTask(id: String, task: TaskModel) -> Observable<Void> {
        return Observable.create { [unowned self] observer in
            let disposables = Disposables.create()
            
            guard let user = self.user else {
                observer.onError(FireDefaultError.unexpected)
                return disposables
            }
            
            let userRef = self.db
                .collection(StringKey.users)
                .document(id)
                .collection(StringKey.tasks)
            
            let taskRef = self.db
                .collection(StringKey.tasks)
            
            userRef.addDocument(data: [StringKey.title: task.title,
                                       StringKey.description: task.description,
                                       StringKey.createdAt: task.createdAt,
                                       StringKey.createUserName: user.displayName,
                                       StringKey.assignedUserName: user.displayName,
                                       StringKey.time: task.time,
                                       StringKey.location: task.location]) { error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return observer.onError(error!)
                }
                
                taskRef.addDocument(data: [StringKey.title: task.title,
                                           StringKey.description: task.description,
                                           StringKey.createdAt: task.createdAt,
                                           StringKey.time: task.time,
                                           StringKey.location: task.location,
                                           StringKey.assignedUserRef: self.db.collection(StringKey.users).document(id),
                                           StringKey.createUserRef: self.db.collection(StringKey.users).document(user.uid)]) { error in
                    guard error == nil else {
                        print(error!.localizedDescription)
                        observer.onError(error!)
                        return
                    }
                    
                    observer.onNext(())
                }
            }
            
            return disposables
        }
    }
    
    // MARK: Get Method
    
    func getAllMyTasks() -> Observable<QuerySnapshot> {
        return Observable.empty()
    }
    
    func getFriendTask(id: String) -> Observable<QuerySnapshot> {
        return Observable.create { [unowned self] observer in
            let disposables = Disposables.create()
            
            guard let user = self.user else {
                observer.onError(FireDefaultError.unexpected)
                return disposables
            }
            
            let tasksRef = self.db.collection(StringKey.tasks)
            
            let myUserRef = self.db.collection(StringKey.users).document(user.uid)
            let userRef = self.db.collection(StringKey.users).document(id)
            
            tasksRef
                .whereField(StringKey.assignedUserRef, isEqualTo: userRef)
                .whereField(StringKey.createUserRef, isEqualTo: myUserRef)
                .addSnapshotListener { snapshot, error in
                    guard error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    snapshot?.documents.forEach { document in
                        let data = document.data()
                        
                        let id = data[StringKey.id] as! String
                        let userTaskRef = userRef.collection(StringKey.tasks)
                        
                        userTaskRef
                            .whereField(StringKey.id, isEqualTo: id)
                            .addSnapshotListener { snapshot, error in
                                guard error == nil else {
                                    print(error!.localizedDescription)
                                    observer.onError(error!)
                                    return
                                }
                                
                                guard let snapshot = snapshot else {
                                    observer.onError(error!)
                                    return
                                }
                                
                                observer.onNext(snapshot)
                            }
                    }
                }
            return disposables
        }
    }
    
    func getAllFriends() -> Observable<QuerySnapshot> {
        return Observable.create { [unowned self] observer in
            let disposables = Disposables.create()
            
            guard let user = self.user else {
                observer.onError(FireDefaultError.unexpected)
                return disposables
            }
            
            let ref = self.db.collection(StringKey.users)
                .document(user.uid)
                .collection(StringKey.friends)
            
            ref.addSnapshotListener { snapshot, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    observer.onError(error!)
                    return
                }
                
                guard let snapshot = snapshot else {
                    observer.onError(error!)
                    return
                }
                
                observer.onNext(snapshot)
            }
            
            return disposables
        }
    }
    
    func getAllFriendsTasks() -> Observable<QuerySnapshot> {
        return Observable.create { observer in
            let disposables = Disposables.create()
            
            guard let user = self.user else {
                observer.onError(FireDefaultError.unexpected)
                return disposables
            }
            
            let taskRef = self.db.collection(StringKey.tasks)
            
            taskRef
                .whereField(StringKey.createUserRef,
                            isEqualTo: self.db.collection(StringKey.users)
                                .document(user.uid))
                .addSnapshotListener { snapshot, error in
                    guard error == nil else {
                        print(error!.localizedDescription)
                        observer.onError(error!)
                        return
                    }
                    
                    guard let snapshot = snapshot else {
                        observer.onError(error!)
                        return
                    }
                    
                    observer.onNext(snapshot)
                }
            return disposables
        }
    }
    
    func getAllUser() -> Observable<QuerySnapshot> {
        return Observable.create { observer in
            
            let ref = self.db.collection(StringKey.users)
            
            ref.addSnapshotListener { snapshot, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    observer.onError(error!)
                    return
                }
                
                guard let snap = snapshot else {
                    observer.onError(error!)
                    return
                }
                
                observer.onNext(snap)
            }
            return Disposables.create()
        }
    }
    
    // MARK: Update Method
    
    func updateTask() -> Observable<QuerySnapshot> {
        return Observable.create { [unowned self] observer in
            let disposables = Disposables.create()
            
            guard let user = self.user else {
                observer.onError(FireDefaultError.unexpected)
                return disposables
            }
            
            let ref = self.db
                .collection(StringKey.users)
                .document(user.uid)
                .collection(StringKey.tasks)
            
            ref.addSnapshotListener { snapshot, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    observer.onError(error!)
                    return
                }
                
                guard let snapshot = snapshot else {
                    observer.onError(error!)
                    return
                }
                observer.onNext(snapshot)
            }
            
            return Disposables.create()
        }
    }
}

extension FirebaseActionModel {
    // MARK: Snapshot Handler
    
    func handleTaskSnapshot(snap: QuerySnapshot, complition: @escaping ([TaskModel]) -> Void) {
        var tasks = [TaskModel]()
        
        snap.documentChanges.forEach { change in
            let task = createTaskModel(change: change)
            tasks.append(task)
        }
        
        complition(tasks)
    }
    
    func handleFriendTaskSnapshot(snap: QuerySnapshot, complition: @escaping ([TaskModel]) -> Void) {
        var tasks = [TaskModel]()
        
        snap.documentChanges.forEach { change in
            let task = createTaskModel(change: change)
            tasks.append(task)
        }
        
        complition(tasks.filter { $0.assignedUserName == user?.displayName })
    }
    
    func handleUserSnapshot(snap: QuerySnapshot, complition: @escaping ([UserModel]) -> Void) {
        var users = [UserModel]()
        
        snap.documentChanges.forEach { change in
            let user = createUserModel(change: change)
            users.append(user)
        }
        complition(users)
    }
    
    // MARK: CreateDataModel
    
    func createUserModel(change: DocumentChange) -> UserModel {
        let data = change.document.data()
        let id = data[StringKey.id] as? String ?? ""
        let name = data[StringKey.name] as? String ?? ""
        
        return UserModel(id: id, name: name)
    }
    
    func createTaskModel(change: DocumentChange) -> TaskModel {
        let data = change.document.data()
        
        let title = data[StringKey.title] as? String ?? ""
        let description = data[StringKey.description] as? String ?? ""
        let createdAt = data[StringKey.createdAt] as? String ?? ""
        let createUserName = data[StringKey.createUserName] as? String ?? ""
        let assignedUserName = data[StringKey.assignedUserName] as? String ?? ""
        let time = data[StringKey.time] as? String ?? ""
        let location = data[StringKey.location] as? String ?? ""
        
        print("created task model")
        
        return TaskModel(title: title,
                         description: description,
                         createdAt: createdAt,
                         createUserName: createUserName,
                         assignedUserName: assignedUserName, time: time, location: location)
    }
}
