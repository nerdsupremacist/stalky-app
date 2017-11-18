//
//  CGRect+Distance.swift
//  Stalky
//
//  Created by Jana Pejić on 18.11.17..
//  Copyright © 2017. Jana Pejić. All rights reserved.
//

import UIKit

extension CGRect {

    func distance(to other: CGRect) -> CGFloat {
        let paths: [KeyPath<CGRect, CGFloat>] = [
            \.origin.x,
            \.origin.y,
        ]
        let differences = paths.map { abs(self[keyPath: $0] - other[keyPath: $0]) }
        return differences.reduce(0.0) { $0 + $1 }
    }

}
