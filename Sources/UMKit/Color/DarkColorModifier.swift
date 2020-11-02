//
// Copyright (c) 2019-Present Umobi - https://github.com/umobi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation
import CoreGraphics

@frozen
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

    @usableFromInline
    class Editable {
        @usableFromInline
        var offset: CGFloat

        @usableFromInline
        var rgbOffset: CGFloat?

        @usableFromInline
        var grayOffset: CGFloat?

        init(_ modifier: DarkColorModifier<Color>) {
            self.offset = modifier.offset
            self.rgbOffset = modifier.rgbOffset
            self.grayOffset = modifier.grayOffset
        }
    }

    @inline(__always) @usableFromInline
    func edit(_ edit: (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }
}

extension DarkColorModifier {

    @inlinable
    public func offset(_ offset: CGFloat) -> Self {
        self.edit {
            $0.offset = offset
        }
    }

    @inlinable
    public func rgbOffset(_ offset: CGFloat) -> Self {
        self.edit {
            $0.rgbOffset = offset
        }
    }

    @inlinable
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
