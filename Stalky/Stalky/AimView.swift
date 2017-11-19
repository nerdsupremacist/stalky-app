//
//  AimView.swift
//  Stalky
//
//  Created by Jana Pejić on 18.11.17..
//  Copyright © 2017. Jana Pejić. All rights reserved.
//

import UIKit

class AimView: UIView {

    private let nameLabel = UILabel()
    private let infoLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    private var blurViewWidthConstraint: NSLayoutConstraint!
    private var blurViewHeightConstraint: NSLayoutConstraint!

    struct Text {
        let name: String
        let additionalInfo: [String]
    }

    var additionalInfoCursor = 0
    var isAnimatingText = false

    var text: Text? {
        didSet {
            guard let text = text else { return }

            infoLabel.text = nil
            nameLabel.text = nil

            let maxLabelSize = CGSize(width: bounds.width, height: .infinity)
            let expectedLabelSizes = text.additionalInfo.map {
                ($0 as NSString).boundingRect(with: maxLabelSize,
                                              options: .usesLineFragmentOrigin,
                                              attributes: [NSAttributedStringKey.font : infoLabel.font],
                                              context: nil)
            }

            let widestLabel = expectedLabelSizes.max {
                $0.width < $1.width
            }!
            let highestLabel = expectedLabelSizes.max {
                $0.height < $1.height
            }!

            blurViewWidthConstraint.constant = widestLabel.width + 30
            blurViewHeightConstraint.constant = highestLabel.height + 30

            isAnimatingText = true
            nameLabel.animate(text: text.name, delay: 0.1, mainColor: .white, intermediateColor: .clear) {
                guard let firstText = text.additionalInfo.first else { return }
                self.infoLabel.animate(text: firstText, delay: 0.1, mainColor: .white, intermediateColor: .clear) {
                    self.isAnimatingText = false
                }
                self.additionalInfoCursor += 1
            }
        }
    }

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

        clipsToBounds = false

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

        // Name label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name: "CourierNewPS-BoldMT", size: 12)
        addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 10).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -10).isActive = true
        nameLabel.topAnchor.constraint(equalTo: blurView.topAnchor, constant: 10).isActive = true

        // Additional info label
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.textColor = .white
        infoLabel.font = UIFont(name: "CourierNewPSMT", size: 12)
        infoLabel.numberOfLines = 0
        addSubview(infoLabel)
        infoLabel.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 10).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -10).isActive = true
        infoLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true

        // Activity indicator
        updateActivityIndicatorColor()
        activityIndicator.alpha = 0.5
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        // Additional info swiping
        isUserInteractionEnabled = true
        let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeUp))
        swipeUpGestureRecognizer.direction = .up
        addGestureRecognizer(swipeUpGestureRecognizer)
        let swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipeDownGestureRecognizer.direction = .down
        addGestureRecognizer(swipeDownGestureRecognizer)

    }

    @objc
    private func handleSwipeUp() {
        guard !isAnimatingText else { return }

        guard additionalInfoCursor < text?.additionalInfo.count ?? 0, let nextText = text?.additionalInfo[additionalInfoCursor] else { return }

        isAnimatingText = true
        infoLabel.text = nil
        infoLabel.animate(text: nextText, delay: 0.1, mainColor: .white, intermediateColor: .clear) {
            self.isAnimatingText = false
        }
        additionalInfoCursor += 1
    }

    @objc
    private func handleSwipeDown() {
        guard !isAnimatingText else { return }

        guard additionalInfoCursor >= 0, let previousText = text?.additionalInfo[additionalInfoCursor] else { return }

        isAnimatingText = true
        infoLabel.text = nil
        infoLabel.animate(text: previousText, delay: 0.1, mainColor: .white, intermediateColor: .clear) {
            self.isAnimatingText = false
        }
        additionalInfoCursor -= 1
    }

    private func updateActivityIndicatorColor() {
        activityIndicator.color = color.uiColor
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
