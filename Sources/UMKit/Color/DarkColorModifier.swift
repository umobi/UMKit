//
//  DarkColorModified.swift
//  UMKit
//
//  Created by brennobemoura on 16/04/20.
//

import Foundation
import CoreGraphics

public struct DarkColorModifier<Color: ColorType>: ColorModifierType {
    let frozedComponent: ColorComponents
    let offset: CGFloat
    let rgbOffset: CGFloat?
    let grayOffset: CGFloat?

    public init(_ color: Color) {
        self.frozedComponent = color.components
        self.offset = 0
        self.rgbOffset = nil
        self.grayOffset = nil
    }

    public init?(hex: String) {
        guard let components = ColorComponents(hex: hex) else {
            return nil
        }

        self.frozedComponent = components
        self.offset = 0
        self.rgbOffset = nil
        self.grayOffset = nil
    }

    private init(_ original: DarkColorModifier<Color>, editable: Editable) {
        self.frozedComponent = original.frozedComponent
        self.offset = editable.offset
        self.rgbOffset = editable.rgbOffset
        self.grayOffset = editable.grayOffset
    }

    fileprivate class Editable {
        var offset: CGFloat
        var rgbOffset: CGFloat?
        var grayOffset: CGFloat?

        init(_ modifier: DarkColorModifier<Color>) {
            self.offset = modifier.offset
            self.rgbOffset = modifier.rgbOffset
            self.grayOffset = modifier.grayOffset
        }
    }

    fileprivate func edit(_ edit: @escaping (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }
}

extension DarkColorModifier {

    public func offset(_ offset: CGFloat) -> Self {
        self.edit {
            $0.offset = offset
        }
    }

    public func rgbOffset(_ offset: CGFloat) -> Self {
        self.edit {
            $0.rgbOffset = offset
        }
    }

    public func grayOffset(_ offset: CGFloat) -> Self {
        self.edit {
            $0.grayOffset = offset
        }
    }
}

extension DarkColorModifier {

    public var components: ColorComponents {
        let components = self.frozedComponent

        guard components.isGrayScale else {
            let offset = self.rgbOffset ?? self.offset

            if offset < 0 {
                return components.darker(with: offset * -1)
            }

            return components.lighter(with: offset)
        }

        let offset = self.grayOffset ?? self.offset

        let darkComponents = ColorComponents(
            red: 1 - components.red,
            green: 1 - components.green,
            blue: 1 - components.blue,
            alpha: components.alpha
        )

        if offset < 0 {
            return darkComponents.darker(with: offset * -1)
        }

        return darkComponents.lighter(with: offset)
    }
}
