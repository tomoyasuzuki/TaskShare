//
//  Reactive.swift
//  TaskShare
//
//  Created by 鈴木友也 on 2019/09/25.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UIViewController {
    private func controlEvent(for selector: Selector) -> ControlEvent<Void> {
        return ControlEvent(events: sentMessage(selector).map { _ in })
    }
    
    var loadView: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.loadView))
    }
    
    var viewWillAppear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewWillAppear))
    }
    
    var viewDidAppear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewDidAppear))
    }
}
