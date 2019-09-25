//
//  ViewController.swift
//  TaskShare
//
//  Created by 鈴木友也 on 2019/09/23.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("--------start test---------")
        
        login()
//        registerUser(name: "tomoya1") // OK
//        registerFriend(id: "xhanE8ajv7U3CXw2oI8Uyva0smN2") //OK
//        registerTask(title: "task1") // OK
//        registerFriendsTask(id: "", title: "friendTask1") // OK
//        getAllMyTasks() // OK
//        getAllFriendsTasks1() // OK
//        getAllFriend() // OK
//        getAllFriendsTask2() // OK
//        getFriendTask(id: "") // OK
        
        print("--------finish test---------")
    }
    
    // Property
    
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore()
    
    // 書き込み系
    
    private func login() {
        Auth.auth().signIn(withEmail: "tomoya.s0121@icloud.com", password: "tomoya0121") { (result, error) in
            guard error == nil else {
                print("error: \(error!.localizedDescription)")
                return
            }
        }
    }
    
    private func registerUser(name: String) {
        guard let user = user else { return }
        
        db.collection("users").document(user.uid).setData(["id": user.uid, "name": name])
    }
    
    private func registerFriend(id: String) {
        guard let user = user else { return }
        let ref = db
            .collection("users")
            .document(user.uid)
            .collection("friends")
        
        ref.document(id)
            .setData(["friendUID": id])
    }
    
    private func registerTask(title: String) {
        guard let user = user else { return }
        
        let userRef = db
            .collection("users")
            .document(user.uid)
            .collection("tasks")
        
        let taskRef = db
            .collection("tasks")
        
        userRef.addDocument(data: ["title": title])
        taskRef.addDocument(data: ["title": title,
                                   "createUserRef": db.collection("users").document(user.uid),
                                   "assignedUserRef": db.collection("users").document(user.uid)])
    }
    
    private func registerFriendsTask(id: String, title: String) {
        guard let user = user else { return }
        
        let userRef = db
            .collection("users")
            .document(id) // Friend UID
            .collection("tasks")
        
        let taskRef = db
            .collection("tasks")
        
        userRef.addDocument(data: ["title": title])
        taskRef.addDocument(data: ["title": title,
                                   "createUserRef": db.collection("users").document(user.uid),
                                   "assignedUserRef": db.collection("users").document(id)])
    }
    
    // 読み取り系
    
    private func updateTasks() {
        
    }
    
    private func getAllMyTasks() {
        guard let user = user else { return }
        
        let ref = db.collection("users").document(user.uid).collection("tasks")
        
        ref.addSnapshotListener { (snapshot, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }

            snapshot?.documents.forEach { (document) in
                let data = document.data()
                print("title: \(data["title"] as! String)")
            }
        }
    }
    
    
    
    private func getAllFriendsTasks1() {
        guard let user = user else { return }
        
        let ref = db.collection("users").document(user.uid).collection("friends")
        
        ref.addSnapshotListener { (snapshot, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            snapshot?.documents.forEach { (document) in
                let data = document.data()
                print("friendUID: \(data["friendUID"] as! String)")
                
                let friendUID = data["friendUID"] as! String
                
                let friendRef = self.db.collection("users").document(friendUID)
                
                let tasksRef = friendRef.collection("tasks")
                
                tasksRef.addSnapshotListener { (snapshot, error) in
                    guard error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    snapshot?.documents.forEach { (document) in
                        let data = document.data()
                        
                        let title = data["title"] as? String
                        
                        print("friendTaskTitle: \(title)")
                    }
                }
            }
        }
    }
    
    private func getAllFriend() {
        guard let user = user else { return }
        
        let ref = db.collection("users").document(user.uid).collection("friends")
        
        ref.addSnapshotListener { (snapshot, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            snapshot?.documents.forEach { (document) in
                let data = document.data()
                print("friendUID: \(data["friendUID"] as! String)")
                
                let friendUID = data["friendUID"] as! String
                
                let friendDocumentRef = self.db.collection("users").document(friendUID)
                
                friendDocumentRef.addSnapshotListener { (snapshot, error) in
                    guard error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    guard let snapshot = snapshot else { return }
                    
                    let data = snapshot.data()
                    
                    let name = data!["name"] as! String
                    
                    print("friendName: \(name)")
                }
            }
        }
    }
    
    private func getAllFriendsTask2() {
        guard let user = user else { return }
        
        let ref = db.collection("tasks")
        
        let myUserRef = db.collection("users").document(user.uid)
        
        ref.whereField("createUserRef", isEqualTo: myUserRef)
            .addSnapshotListener { (snapshot, error) in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                // 現状自分のタスクまで取ってきているので修正が必要
                
                snapshot?.documents.forEach { (document) in
                    let data = document.data()
                    
                    print("title: \(data["title"] as! String)")
                }
        }
    }
    
    
    
    private func getFriendTask(id: String) {
        guard let user = user else { return }
        
        let tasksRef = db.collection("tasks")
        
        let myUserRef = db.collection("users").document(user.uid)
        let userRef = db.collection("users").document(id)
        
        tasksRef
            .whereField("assignedUserRef", isEqualTo: userRef)
            .whereField("createUserRef", isEqualTo: myUserRef)
            .addSnapshotListener { (snapshot, error) in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                snapshot?.documents.forEach { (document) in
                    let data = document.data()
                    
                    let title = data["title"] as! String
                    
                    print("friendTaskTitle: \(title)")
                 }
        }
    }
    
    private func getAllUser() {
        let userRef = db.collection("users")
        
        userRef.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach { (change) in
                let data = change.document.data()
                
                let name = data["name"] as! String
                
                print("username: \(name)")
            }
        }
    }
}

