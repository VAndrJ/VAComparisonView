//
//  ViewController.swift
//  VAComparisonView
//
//  Created by Volodymyr Andriienko on 04/06/2024.
//  Copyright (c) 2024 Volodymyr Andriienko. All rights reserved.
//

import UIKit
import VAComparisonView

class ViewController: UIViewController {
    @IBOutlet private weak var comparisonView: VAComparisonView! {
        didSet {
            comparisonView.add(view: ExampleView(kind: .summer), order: .first)
            comparisonView.add(view: ExampleView(kind: .winter), order: .second)
            comparisonView.divider = .standard(configuration: .init(width: 5, color: .green))
        }
    }
    private lazy var comparisonPView = VAComparisonView(
        first: ExampleView(kind: .summer),
        second: ExampleView(kind: .winter)
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        addElements()
    }

    private func addElements() {
        view.addAutolayoutSubview(comparisonPView)
        comparisonPView
            .anchor(.top, opposedTo: comparisonView, constant: 8)
            .toSuperAxis(.horizontal, isSafe: true)
            .size(height: 200)
    }
}
