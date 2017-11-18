//
//  AimView.swift
//  Stalky
//
//  Created by Jana Pejić on 18.11.17..
//  Copyright © 2017. Jana Pejić. All rights reserved.
//

import UIKit

class AimView: UIView {

    private let infoLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    private var blurViewWidthConstraint: NSLayoutConstraint!
    private var blurViewHeightConstraint: NSLayoutConstraint!

    enum Color {
        case red
        case green
        case blue
        case yellow
        case white
    }

    var color: Color = .red {
        didSet {
            setNeedsDisplay()
            updateActivityIndicatorColor()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setup() {
        // Blurred background

        let blurView = UIView()
        blurView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blurView)

        blurView.topAnchor.constraint(equalTo: bottomAnchor, constant: 10).isActive = true
        blurView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        blurViewWidthConstraint = blurView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        blurViewWidthConstraint.isActive = true
        blurViewHeightConstraint = blurView.heightAnchor.constraint(equalToConstant: 0)
        blurViewHeightConstraint.isActive = true

        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.layer.cornerRadius = 5
        visualEffectView.clipsToBounds = true

        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurView.addSubview(visualEffectView)

        visualEffectView.leadingAnchor.constraint(equalTo: blurView.leadingAnchor).isActive = true
        visualEffectView.trailingAnchor.constraint(equalTo: blurView.trailingAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: blurView.topAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: blurView.bottomAnchor).isActive = true

        // Label

        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.textColor = .white
        infoLabel.font = UIFont(name: "CourierNewPS-BoldMT", size: 12)
        infoLabel.numberOfLines = 0
        addSubview(infoLabel)
        clipsToBounds = false
        infoLabel.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 10).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -10).isActive = true
        infoLabel.topAnchor.constraint(equalTo: blurView.topAnchor, constant: 10).isActive = true

        // Activity indicator

        updateActivityIndicatorColor()
        activityIndicator.alpha = 0.5
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        activityIndicator.startAnimating()
    }

    private func updateActivityIndicatorColor() {
        activityIndicator.color = color.uiColor
    }

    func animate(text: String) {
        infoLabel.text = nil

        let maxLabelSize = CGSize(width: bounds.width, height: .infinity)
        let expectedLabelSize = (text as NSString).boundingRect(with: maxLabelSize,
                                                                options: .usesLineFragmentOrigin,
                                                                attributes: [NSAttributedStringKey.font : infoLabel.font],
                                                                context: nil)
        blurViewWidthConstraint.constant = expectedLabelSize.width + 30
        blurViewHeightConstraint.constant = expectedLabelSize.height + 30

        infoLabel.animate(text: text, delay: 0.1, mainColor: .white, intermediateColor: .clear)
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.setStrokeColor(color.cgColor)
        context.setFillColor(UIColor.clear.cgColor)

        // Drawing the corners
        context.setLineWidth(15)
        let cornerSideLength = (rect.width + rect.height) / 2 / 10

        // Drawing the top left corner
        context.move(to: CGPoint(x: 0, y: 0))
        context.addLine(to: CGPoint(x: 0, y: cornerSideLength))
        context.strokePath()

        context.move(to: CGPoint(x: 0, y: 0))
        context.addLine(to: CGPoint(x: cornerSideLength, y: 0))
        context.strokePath()

        // Drawing the top right corner
        context.move(to: CGPoint(x: rect.width, y: 0))
        context.addLine(to: CGPoint(x: rect.width, y: cornerSideLength))
        context.strokePath()

        context.move(to: CGPoint(x: rect.width, y: 0))
        context.addLine(to: CGPoint(x: rect.width - cornerSideLength, y: 0))
        context.strokePath()

        // Drawing the bottom left corner
        context.move(to: CGPoint(x: 0, y: rect.height))
        context.addLine(to: CGPoint(x: 0, y: rect.height - cornerSideLength))
        context.strokePath()

        context.move(to: CGPoint(x: 0, y: rect.height))
        context.addLine(to: CGPoint(x: cornerSideLength, y: rect.height))
        context.strokePath()

        // Drawing the bottom right corner
        context.move(to: CGPoint(x: rect.width, y: rect.height))
        context.addLine(to: CGPoint(x: rect.width, y: rect.height - cornerSideLength))
        context.strokePath()

        context.move(to: CGPoint(x: rect.width, y: rect.height))
        context.addLine(to: CGPoint(x: rect.width - cornerSideLength, y: rect.height))
        context.strokePath()

        // Drawing the middle dashes
        context.setLineWidth(5)
        let dashLength = 1.2 * cornerSideLength

        // Drawing the top middle dash
        context.move(to: CGPoint(x: rect.width / 2, y: 0))
        context.addLine(to: CGPoint(x: rect.width / 2, y: dashLength))
        context.strokePath()

        // Drawing the right middle dash
        context.move(to: CGPoint(x: rect.width, y: rect.height / 2))
        context.addLine(to: CGPoint(x: rect.width - dashLength, y: rect.height / 2))
        context.strokePath()

        // Drawing the bottom middle dash
        context.move(to: CGPoint(x: rect.width / 2, y: rect.height))
        context.addLine(to: CGPoint(x: rect.width / 2, y: rect.height - dashLength))
        context.strokePath()

        // Drawing the left middle dash
        context.move(to: CGPoint(x: 0, y: rect.height / 2))
        context.addLine(to: CGPoint(x: dashLength, y: rect.height / 2))
        context.strokePath()

        // Drawing the dashed border line
        context.setLineWidth(5)
        context.setLineDash(phase: cornerSideLength, lengths: [6, 3])
        context.addRect(rect)
        context.closePath()
        context.strokePath()
        context.drawPath(using: .stroke)
    }

    func startProgress() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func stopProgress() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }

}

extension AimView.Color {
    var cgColor: CGColor {
        return uiColor.cgColor
    }

    var uiColor: UIColor {
        switch self {
        case .red:
            return .red
        case .green:
            return .green
        case .blue:
            return .blue
        case .yellow:
            return .yellow
        case .white:
            return .white
        }
    }
}
