//
//  TaskDetailViewController.swift
//  TaskShare
//
//  Created by 鈴木友也 on 2019/10/02.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    // MARK: Property
    
    lazy var titleLabel: TitleLabel = {
        let label = TitleLabel()
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    lazy var descriptionLabel: DescriptionLabel = {
        let label = DescriptionLabel()
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    lazy var timeLabel: DescriptionLabel = {
        let label = DescriptionLabel()
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    lazy var locationLabel: DescriptionLabel = {
        let label = DescriptionLabel()
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(timeLabel)
        view.addSubview(locationLabel)
        
        configureConstraints()
    }
}

extension TaskDetailViewController {
    func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view).offset(70)
            make.left.equalTo(view).offset(50)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.equalTo(titleLabel)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.left.equalTo(titleLabel)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(16)
            make.left.equalTo(titleLabel)
        }
    }
}
