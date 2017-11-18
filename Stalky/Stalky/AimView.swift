//
//  AimView.swift
//  Stalky
//
//  Created by Jana Pejić on 18.11.17..
//  Copyright © 2017. Jana Pejić. All rights reserved.
//

import UIKit

class AimView: UIView {
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.setStrokeColor(UIColor.red.cgColor)
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
