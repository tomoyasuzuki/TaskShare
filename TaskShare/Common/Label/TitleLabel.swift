//
//  TitleLabel.swift
//  TaskShare
//
//  Created by 鈴木友也 on 2019/09/25.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import Foundation
import UIKit

final class TitleLabel: UILabel {
    init() {
        super.init(frame: CGRect.zero)
        textColor = .black
        font = .boldSystemFont(ofSize: 18.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
