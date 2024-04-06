//
//  BaseView.swift
//  VAComparisonView_Example
//
//  Created by Volodymyr Andriienko on 06.04.2024.
//  Copyright © 2024 Volodymyr Andriienko. All rights reserved.
//

import UIKit

class BaseView: UIView {

    init() {
        super.init(frame: .init(x: 0, y: 0, width: 240, height: 128))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
