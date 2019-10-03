//
//  ButtonTableViewCell.swift
//  TaskShare
//
//  Created by 鈴木友也 on 2019/10/03.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import UIKit
import SnapKit

protocol ButtonTableViewCellDelegate {
    func buttonTapped(cell: Int) -> Void
}

class ButtonTableViewCell: UITableViewCell {
    
    var delegate: ButtonTableViewCellDelegate?
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        button.contentEdgeInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
        button.backgroundColor = UIColor.hex(string: "#4169e1", alpha: 1.0)
        button.layer.cornerRadius = 8.0
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(button)
        contentView.addSubview(label)
        
        accessoryType = .none
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ButtonTableViewCell {
    func configureDataSource(user: UserModel) {
        label.text = user.name
    }
    
    private func configureConstraints() {
        label.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(8)
        }
        button.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-8)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
    }
    
    @objc func buttonTapped() {
        delegate?.buttonTapped(cell: self.tag)
    }
}
