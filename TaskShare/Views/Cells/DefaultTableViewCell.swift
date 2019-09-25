//
//  DefaultTableViewCell.swift
//  TaskShare
//
//  Created by 鈴木友也 on 2019/09/25.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import Foundation
import UIKit

final class DefaultTableViewCell: UITableViewCell {
    
    static let height: CGFloat = 160.0
    
    private lazy var titleLabel: UILabel = {
        return TitleLabel()
    }()
    
    private lazy var createUserTitleLabel: UILabel = {
        return DescriptionLabel()
    }()
    
    private lazy var createUserDescriptionLabel: UILabel = {
        return DescriptionLabel()
    }()
    
    private lazy var assignedUserTitleLabel: UILabel = {
        return DescriptionLabel()
    }()
    
    private lazy var assignedUserDescriptionLabel: UILabel = {
        return DescriptionLabel()
    }()
    
    private lazy var timeLabel: UILabel = {
        return DescriptionLabel()
    }()
    
    private lazy var locationLabel: UILabel = {
        return DescriptionLabel()
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(createUserTitleLabel)
        contentView.addSubview(createUserDescriptionLabel)
        contentView.addSubview(assignedUserTitleLabel)
        contentView.addSubview(assignedUserDescriptionLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(locationLabel)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DefaultTableViewCell {
    func build(task: TaskModel) {
        titleLabel.text = task.title
    
        createUserTitleLabel.text = "Creater:"
        assignedUserTitleLabel.text = "Assignee:"
        
        createUserDescriptionLabel.text = task.createUserName
        assignedUserDescriptionLabel.text = task.assignedUserName
        
        timeLabel.text = task.time
        locationLabel.text = task.location
    }
}


extension DefaultTableViewCell {
    private func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(16)
            make.left.equalTo(contentView).offset(16)
        }
        
        createUserTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel)
        }
        
        createUserDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(createUserTitleLabel)
            make.left.equalTo(createUserTitleLabel.snp.right).offset(8)
        }
        
        assignedUserTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(createUserTitleLabel)
            make.left.equalTo(createUserDescriptionLabel.snp.right).offset(8)
        }
        
        assignedUserDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(createUserTitleLabel)
            make.left.equalTo(assignedUserTitleLabel.snp.right).offset(8)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(createUserTitleLabel.snp.bottom).offset(16)
            make.left.equalTo(titleLabel)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel)
        }
    }
}
