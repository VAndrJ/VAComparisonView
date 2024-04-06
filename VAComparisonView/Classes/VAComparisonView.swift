//
//  VAComparisonViews.swift
//  VAComparisonView
//
//  Created by Volodymyr Andriienko on 06.04.2024.
//

import UIKit

open class VAComparisonView: UIView {
    public enum Order {
        case first
        case second
    }

    public enum Divider {
        case standard(configuration: DividerConfiguration = .standard)
        case custom(CALayer)

        var width: CGFloat {
            switch self {
            case let .standard(configuration): return configuration.width
            case let .custom(layer): return layer.frame.width
            }
        }
    }

    public struct DividerConfiguration {
        public static var standard: Self { .init(width: 2, color: .white) }

        public let width: CGFloat
        public let color: UIColor

        public init(width: CGFloat, color: UIColor) {
            self.width = width
            self.color = color
        }
    }

    public var divider: Divider? = .standard() {
        didSet { updateDivider() }
    }
    public private(set) var dividerLayer: CALayer?
    public let firstContainerView = UIView()
    public let secondContainerView = UIView()
    public let maskLayer = CALayer()
    public private(set) var position: CGFloat = 0.5 {
        didSet { updateMaskFrame() }
    }
    public var isShowBoth = false {
        didSet { showBothIfNeeded() }
    }

    public convenience init(first: UIView, second: UIView) {
        self.init(frame: .init(x: 0, y: 0, width: 240, height: 128))

        add(view: first, order: .first)
        add(view: second, order: .second)
    }

    public convenience init() {
        self.init(frame: .init(x: 0, y: 0, width: 240, height: 128))
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        addElements()
        configure()
        bind()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)

        addElements()
        configure()
        bind()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        updateMaskFrame(isLayout: true)
    }

    public func add(view: UIView, order: Order) {
        switch order {
        case .first:
            assert(firstContainerView.subviews.isEmpty)
            add(view, to: firstContainerView)
        case .second:
            assert(secondContainerView.subviews.isEmpty)
            add(view, to: secondContainerView)
        }
    }

    private func updateDivider() {
        dividerLayer?.removeFromSuperlayer()
        dividerLayer = nil
        if let divider {
            switch divider {
            case let .standard(configuration):
                let dividerLayer = CALayer()
                dividerLayer.backgroundColor = configuration.color.cgColor
                self.layer.addSublayer(dividerLayer)
                self.dividerLayer = dividerLayer
            case let .custom(layer):
                self.layer.addSublayer(layer)
                self.dividerLayer = layer
            }
            updateDividerFrame()
        }
    }

    private func updateMaskFrame(isLayout: Bool = false) {
        let width = position * bounds.width
        let newRect = CGRect(x: 0, y: 0, width: width, height: bounds.height)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        animateIfNeeded(isLayout: isLayout, layer: maskLayer, newFrame: newRect)
        maskLayer.frame = newRect
        CATransaction.commit()
        updateDividerFrame(isLayout: isLayout)
    }

    private func updateDividerFrame(isLayout: Bool = false) {
        guard let dividerLayer, let divider else { return }
        
        let width = position * bounds.width
        let newRect = CGRect(x: width - divider.width / 2, y: 0, width: divider.width, height: bounds.height)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        animateIfNeeded(isLayout: isLayout, layer: dividerLayer, newFrame: newRect)
        dividerLayer.frame = newRect
        CATransaction.commit()
    }

    private func animateIfNeeded(isLayout: Bool, layer: CALayer, newFrame: CGRect) {
        if isLayout, let referenceAnimation = self.layer.presentation()?.animation(forKey: "bounds.size") {
            let sizeAnimation = getAnimation(
                keyPath: "bounds.size",
                from: layer.bounds.size,
                to: newFrame.size,
                reference: referenceAnimation
            )
            layer.add(sizeAnimation, forKey: sizeAnimation.keyPath)
            let positionAnimation = getAnimation(
                keyPath: "position",
                from: layer.position,
                to: CGPoint(x: newFrame.midX, y: newFrame.midY),
                reference: referenceAnimation
            )
            layer.add(positionAnimation, forKey: positionAnimation.keyPath)
        }
    }

    private func bind() {
        addGestureRecognizer(UIPanGestureRecognizer(
            target: self,
            action: #selector(onPan(_:))
        ))
        let tapWithTwoFingersGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(onTapWithTwoFingers(_:))
        )
        tapWithTwoFingersGesture.numberOfTouchesRequired = 2
        addGestureRecognizer(tapWithTwoFingersGesture)
    }

    @objc private func onPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            position = max(0, min(1, position + sender.translation(in: self).x / bounds.width))
            sender.setTranslation(.zero, in: self)
        default:
            break
        }
    }

    @objc private func onTapWithTwoFingers(_ sender: UITapGestureRecognizer) {
        guard sender.state == .recognized else { return }

        isShowBoth.toggle()
    }

    open func showBothIfNeeded() {
        if isShowBoth {
            dividerLayer?.opacity = 0
            firstContainerView.layer.mask = nil
            firstContainerView.alpha = 0.5
        } else {
            dividerLayer?.opacity = 1
            firstContainerView.layer.mask = maskLayer
            firstContainerView.alpha = 1
        }
    }

    private func configure() {
        isUserInteractionEnabled = true
        secondContainerView.layer.masksToBounds = true
        maskLayer.backgroundColor = UIColor.black.cgColor
        updateDivider()
    }

    private func addElements() {
        add(secondContainerView, to: self)
        add(firstContainerView, to: self)
        firstContainerView.layer.mask = maskLayer
    }

    private func add(_ view: UIView, to container: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: container.topAnchor),
            view.leftAnchor.constraint(equalTo: container.leftAnchor),
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            view.rightAnchor.constraint(equalTo: container.rightAnchor),
        ])
    }
}

private func getAnimation(
    keyPath: String,
    from: Any,
    to: Any,
    reference: CAAnimation
) -> CABasicAnimation {
    let animation = CABasicAnimation(keyPath: keyPath)
    animation.fromValue = from
    animation.toValue = to
    animation.duration = reference.duration
    animation.timingFunction = reference.timingFunction
    animation.fillMode = reference.fillMode
    if #available(iOS 15.0, *) {
        animation.preferredFrameRateRange = reference.preferredFrameRateRange
    }

    return animation
    }
