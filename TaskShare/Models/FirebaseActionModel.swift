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
    func registerUser(name: String) -> Observable<Void>
    func registerFriend(id: String) -> Observable<Void>
    func registerTask(task: TaskModel) -> Observable<Void>
    func registerFriendTask(id: String, task: TaskModel) -> Observable<Void>
    func updateTask() -> Observable<QuerySnapshot>
    func getAllMyTasks() -> Observable<QuerySnapshot>
    func getFriendTask(id: String) -> Observable<QuerySnapshot>
    func getAllFriends() -> Observable<QuerySnapshot>
}

final class FirebaseActionModel: FirebaseActionProtocol {
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    func login(email: String, password: String) -> Observable<Void> {
        return Observable.create { observer in
            Auth.auth().signIn(withEmail: email, password: password) { _, error in
                guard error == nil else {
                    print("error: \(error!.localizedDescription)")
                    observer.onError(error!)
                    return
                }
                
                observer.onNext(())
            }
            return Disposables.create()
        }
    }
    
    func registerUser(name: String) -> Observable<Void> {
        return Observable.create { [unowned self] observer in
            let disposables = Disposables.create()
            
            guard let user = self.user else {
                observer.onError(FireAuthError.unexpected)
                return disposables
            }
            
            self.db.collection("users").document(user.uid).setData(["id": user.uid, "name": name]) { error in
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
    
    func registerFriend(id: String) -> Observable<Void> {
        return Observable.create { [unowned self] observer in
            let disposables = Disposables.create()
            
            guard let user = self.user else {
                observer.onError(FireDefaultError.unexpected)
                return disposables
            }
            
            let ref = self.db
                .collection("users")
                .document(user.uid)
                .collection("friends")
            
            ref.document(id)
                .setData(["id": id]) { error in
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
    
    func registerTask(task: TaskModel) -> Observable<Void> {
        return Observable.create { [unowned self] observer in
            let disposables = Disposables.create()
            
            guard let user = self.user else {
                observer.onError(FireAuthError.unexpected)
                return disposables
            }
            
            let userRef = self.db
                .collection("users")
                .document(user.uid)
                .collection("tasks")
            
            let taskRef = self.db
                .collection("tasks")
            
            userRef.addDocument(data: ["title": task.title,
                                       "description": task.description,
                                       "createdAt": task.createdAt,
                                       "createUserName": user.displayName!,
                                       "assignedUserName": user.displayName!,
                                       "time": task.time,
                                       "lcoation": task.location]) { error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return observer.onError(error!)
                }
                
                taskRef.addDocument(data: ["title": task.title,
                                           "createUserRef": self.db.collection("users").document(user.uid),
                                           "assignedUserRef": self.db.collection("users").document(user.uid)]) { error in
                    
                    guard error == nil else {
                        print(error!.localizedDescription)
                        observer.onError(error!)
                        return
                    }
                    
                    observer.onNext(())
                }
            }
            
            return Disposables.create()
        }
    }
    
    func registerFriendTask(id: String, task: TaskModel) -> Observable<Void> {
        return Observable.create { _ in
            let disposables = Disposables.create()
            
            return disposables
        }
    }
    
    func updateTask() -> Observable<QuerySnapshot> {
        return Observable.create { [unowned self] observer in
            let disposables = Disposables.create()
            
            guard let user = self.user else {
                observer.onError(FireDefaultError.unexpected)
                return disposables
            }
            
            let ref = self.db.collection("users").document(user.uid).collection("tasks")
            
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
            
            let tasksRef = self.db.collection("tasks")
            
            let myUserRef = self.db.collection("users").document(user.uid)
            let userRef = self.db.collection("users").document(id)
            
            tasksRef
                .whereField("assignedUserRef", isEqualTo: userRef)
                .whereField("createUserRef", isEqualTo: myUserRef)
                .addSnapshotListener { snapshot, error in
                    guard error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    snapshot?.documents.forEach { document in
                        let data = document.data()
                        
                        let id = data["id"] as! String
                        print("taskid:" +  id)
                        
                        let userTaskRef = userRef.collection("tasks")
                            
                        userTaskRef
                          .whereField("id", isEqualTo: id)
                            .addSnapshotListener { (snapshot, error) in
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
        return Observable.create { [unowned self] observer  in
            let disposables = Disposables.create()
            
            let ref = self.db.collection("friends")
            
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
}

extension FirebaseActionModel {
    func handleSnapshot(snap: QuerySnapshot, complition: @escaping ([TaskModel]) -> Void) {
        snap.documents.forEach { change in
            var tasks = [TaskModel]()
            
            let data = change.data()
            
            let title = data["title"] as! String
            let description = data["description"] as! String
            let createdAt = data["createdAt"] as! String
            let createUserName = data["createUserName"] as! String
            let assignedUserName = data["assignedUserName"] as! String
            let time = data["time"] as! String
            let location = data["location"] as! String
            
            let task = TaskModel(title: title,
                                 description: description,
                                 createdAt: createdAt,
                                 createUserName: createUserName,
                                 assignedUserName: assignedUserName, time: time, location: location)
            
            print(title)
            
            tasks.append(task)
            
            complition(tasks)
        }
    }
}
