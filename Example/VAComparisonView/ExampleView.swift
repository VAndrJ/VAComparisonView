//
//  ExampleView.swift
//  VAComparisonView_Example
//
//  Created by Volodymyr Andriienko on 06.04.2024.
//  Copyright © 2024 Volodymyr Andriienko. All rights reserved.
//

import UIKit

class ExampleView: BaseView {
    enum Kind: String {
        case summer
        case winter

        var image: UIImage {
            switch self {
            case .summer: return VAAssets.Image.summer
            case .winter: return VAAssets.Image.winter
            }
        }
        var title: String { rawValue.uppercased() }
    }

    private let imageView = UIImageView().apply {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    private let titleLabel = UILabel().apply {
        $0.textColor = .black
    }

    let kind: Kind

    init(kind: Kind) {
        self.kind = kind

        super.init()

        addElements()
        configure()
    }

    private func configure() {
        imageView.image = kind.image
        titleLabel.text = kind.title
    }

    private func addElements() {
        addAutolayoutSubviews(imageView, titleLabel)
        imageView
            .toSuperEdges()
        titleLabel
            .toSuper(.top)
            .toSuper(kind == .summer ? .left : .right)
    }
}
