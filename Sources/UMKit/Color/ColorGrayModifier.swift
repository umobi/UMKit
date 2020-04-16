//
//  ColorGrayModifier.swift
//  UMKit
//
//  Created by brennobemoura on 16/04/20.
//

import Foundation
import UIKit

struct ColorGrayModifier<Color: ColorType>: ColorModifierType {
    private let color: Color

    init(_ color: Color) {
        self.color = color
    }

    var components: UIColor.Components {
        let components = self.color.components

        guard !components.isGrayScale else {
            return components
        }

        let grayAvg = (components.red + components.blue + components.green) / 3.0

        return .init(red: grayAvg, green: grayAvg, blue: grayAvg, alpha: components.alpha)
    }
}
