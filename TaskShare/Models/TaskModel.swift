//
//  TaskModel.swift
//  TaskShare
//
//  Created by 鈴木友也 on 2019/09/24.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//
import Foundation

class TaskModel {
    let title: String
    let description: String
    let createdAt: Date
    let time: Date
    let location: String
    
    init(title: String, description: String, createdAt: Date, time: Date, location: String) {
        self.title = title
        self.description = description
        self.createdAt = createdAt
        self.time = time
        self.location = location
    }
}
