//
//  ColorGrayModifier.swift
//  UMKit
//
//  Created by brennobemoura on 16/04/20.
//

import Foundation
import UIKit

public struct ColorGrayModifier<Color: ColorType>: ColorModifierType {
    private let frozedComponent: UMColor.Components

    public init(_ color: Color) {
        self.frozedComponent = color.components
    }

    public init?(hex: String) {
        guard let components = UMColor.Components(hex: hex) else {
            return nil
        }

        self.frozedComponent = components
    }

    public var components: UMColor.Components {
        let components = self.frozedComponent

        guard !components.isGrayScale else {
            return components
        }

        let grayAvg = (components.red + components.blue + components.green) / 3.0

        return .init(red: grayAvg, green: grayAvg, blue: grayAvg, alpha: components.alpha)
    }
}
