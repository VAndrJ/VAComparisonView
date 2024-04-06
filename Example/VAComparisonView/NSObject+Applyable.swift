//
//  NSObject+Applyable.swift
//  VAComparisonView_Example
//
//  Created by Volodymyr Andriienko on 06.04.2024.
//  Copyright © 2024 Volodymyr Andriienko. All rights reserved.
//

import Foundation

protocol Applyable {}

extension Applyable {

    func apply(configure: (Self) -> Void) -> Self {
        configure(self)
        
        return self
    }
}

extension NSObject: Applyable {}
