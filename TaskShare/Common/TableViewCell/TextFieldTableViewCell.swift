//
//  TextFieldTableViewCell.swift
//  TaskShare
//
//  Created by 鈴木友也 on 2019/09/27.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(inputTextField)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}

extension TextFieldTableViewCell {
    private func configureConstraints() {
        inputTextField.snp.makeConstraints { make in
            make.top.left.equalTo(contentView).offset(4)
            make.bottom.right.equalTo(contentView).offset(-4)
        }
    }
}
