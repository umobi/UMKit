//
//  ColorGrayModifier.swift
//  UMKit
//
//  Created by brennobemoura on 16/04/20.
//

import Foundation
import UIKit

public struct ColorGrayModifier<Color: ColorType>: ColorModifierType {
    private let color: Color

    public init(_ color: Color) {
        self.color = color
    }

    public var components: UMColor.Components {
        let components = self.color.components

        guard !components.isGrayScale else {
            return components
        }

        let grayAvg = (components.red + components.blue + components.green) / 3.0

        return .init(red: grayAvg, green: grayAvg, blue: grayAvg, alpha: components.alpha)
    }
}
