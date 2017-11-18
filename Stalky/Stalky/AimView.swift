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
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.textColor = .white
        infoLabel.font = UIFont(name: "CourierNewPS-BoldMT", size: 20)
        infoLabel.numberOfLines = 0
        addSubview(infoLabel)
        clipsToBounds = false
        infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        infoLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: 20).isActive = true
    }

    func animate(text: String) {
        infoLabel.text = nil
        infoLabel.animate(text: text, delay: 0.1)
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

}

extension AimView.Color {
    var cgColor: CGColor {
        let color: UIColor
        switch self {
        case .red:
            color = .red
        case .green:
            color = .green
        case .blue:
            color = .blue
        case .yellow:
            color = .yellow
        case .white:
            color = .white
        }
        return color.cgColor
    }
}
