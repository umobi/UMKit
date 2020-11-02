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
import SwiftUI
#if os(macOS)
import AppKit
#else
import UIKit
#endif

public protocol ColorFactoryType {
    associatedtype Color: ColorType

    var color: SwiftUI.Color { get }
    #if os(macOS)
    var nsColor: NSColor { get }
    #else
    var uiColor: UIColor { get }
    #endif
    var components: ColorComponents { get }

    func lighter(_ constant: CGFloat) -> ColorFactory<Color>
    func darker(_ constant: CGFloat) -> ColorFactory<Color>

    #if os(iOS) || os(tvOS) || os(macOS)
    func darkColor(_ color: Color) -> ColorFactory<Color>
    func darkColor<DarkColor: ColorType>(_ color: DarkColor) -> ColorFactory<Color>
    func darkColor<Factory: ColorFactoryType>(_ factory: Factory) -> ColorFactory<Color>

    func lightColor(_ color: Color) -> ColorFactory<Color>
    func lightColor<LightColor: ColorType>(_ color: LightColor) -> ColorFactory<LightColor>
    func lightColor<Factory: ColorFactoryType>(_ factory: Factory) -> ColorFactory<Factory.Color>
    #endif

    func red(_ red: CGFloat) -> ColorFactory<Color>
    func green(_ green: CGFloat) -> ColorFactory<Color>
    func blue(_ blue: CGFloat) -> ColorFactory<Color>

    func alpha(_ alpha: CGFloat) -> ColorFactory<Color>
}

public extension ColorFactoryType {
    func alpha(_ alpha: CGFloat) -> ColorFactory<Color> {
        ColorFactory<Color>(self.components)
            .alpha(alpha)
    }

    func red(_ red: CGFloat) -> ColorFactory<Color> {
        ColorFactory<Color>(self.components)
            .red(red)
    }

    func green(_ green: CGFloat) -> ColorFactory<Color> {
        ColorFactory<Color>(self.components)
            .green(green)
    }

    func blue(_ blue: CGFloat) -> ColorFactory<Color> {
        ColorFactory<Color>(self.components)
            .blue(blue)
    }
}

#if os(iOS) || os(tvOS) || os(macOS)
public extension ColorFactoryType {

    func darkColor(_ color: Color) -> ColorFactory<Color> {
        ColorFactory<Color>(self.components)
            .darkColor(color)
    }

    func darkColor<DarkColor: ColorType>(_ color: DarkColor) -> ColorFactory<Color> {
        ColorFactory<Color>(self.components)
            .darkColor(color)
    }

    func darkColor<Factory: ColorFactoryType>(_ factory: Factory) -> ColorFactory<Color> {
        ColorFactory<Color>(self.components)
            .darkColor(factory)
    }
}

public extension ColorFactoryType {

    func lightColor(_ color: Color) -> ColorFactory<Color> {
        ColorFactory<Color>(self.components)
            .lightColor(color)
    }

    func lightColor<LightColor>(_ color: LightColor) -> ColorFactory<LightColor> where LightColor: ColorType {
        ColorFactory<LightColor>(self.components)
            .lightColor(color)
    }

    func lightColor<Factory>(_ factory: Factory) -> ColorFactory<Factory.Color> where Factory: ColorFactoryType {
        ColorFactory<Factory.Color>(self.components)
            .lightColor(factory)
    }
}
#endif

public extension ColorFactoryType {
    func lighter(_ constant: CGFloat) -> ColorFactory<Color> {
        ColorFactory<Color>(self.components)
            .lighter(constant)
    }

    func darker(_ constant: CGFloat) -> ColorFactory<Color> {
        ColorFactory<Color>(self.components)
            .darker(constant)
    }
}

public extension ColorFactoryType {
    var color: SwiftUI.Color {
        ColorFactory<Color>(self.components)
            .color
    }
    #if os(macOS)
    var nsColor: NSColor {
        ColorFactory<Color>(self.components)
            .nsColor
    }
    #else
    var uiColor: UIColor {
        ColorFactory<Color>(self.components)
            .uiColor
    }
    #endif
}
