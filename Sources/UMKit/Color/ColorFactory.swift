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

@frozen
public struct ColorFactory<Color: ColorType>: ColorFactoryType {
    let alpha: CGFloat
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat

    #if !os(watchOS)
    let darkColor: ColorComponents?
    #endif

    @usableFromInline
    init(_ color: Color) {
        guard let components = ColorComponents.component(from: color.rawValue) else {
            fatalError()
        }

        self.alpha = components.alpha
        self.red = components.red
        self.green = components.green
        self.blue = components.blue
        #if !os(watchOS)
        self.darkColor = nil
        #endif
    }

    @usableFromInline
    init(_ components: ColorComponents) {
        self.alpha = components.alpha
        self.red = components.red
        self.green = components.green
        self.blue = components.blue
        #if !os(watchOS)
        self.darkColor = nil
        #endif
    }

    private init(_ original: ColorFactory<Color>, editable: Editable) {
        self.alpha = editable.alpha
        self.red = editable.red
        self.green = editable.green
        self.blue = editable.blue
        #if !os(watchOS)
        self.darkColor = editable.darkColor
        #endif
    }

    @usableFromInline
    class Editable {
        @usableFromInline
        var alpha: CGFloat

        @usableFromInline
        var red: CGFloat

        @usableFromInline
        var green: CGFloat

        @usableFromInline
        var blue: CGFloat

        #if !os(watchOS)
        @usableFromInline
        var darkColor: ColorComponents?
        #endif

        init(_ colorFactory: ColorFactory<Color>) {
            self.alpha = colorFactory.alpha
            self.red = colorFactory.red
            self.green = colorFactory.green
            self.blue = colorFactory.blue
            #if !os(watchOS)
            self.darkColor = colorFactory.darkColor
            #endif
        }
    }

    @inline(__always) @usableFromInline
    func edit(_ edit: (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }
}

public extension ColorFactory {
    @inlinable
    func alpha(_ alpha: CGFloat) -> Self {
        self.edit {
            $0.alpha = alpha

            #if !os(watchOS)
            if let darkColor = $0.darkColor {
                $0.darkColor = .init(
                    red: darkColor.red,
                    green: darkColor.green,
                    blue: darkColor.blue,
                    alpha: alpha
                )
            }
            #endif
        }
    }

    @inlinable
    func red(_ red: CGFloat) -> ColorFactory<Color> {
        self.edit {
            $0.red = red / 255.0
        }
    }

    @inlinable
    func green(_ green: CGFloat) -> ColorFactory<Color> {
        self.edit {
            $0.green = green / 255.0
        }
    }

    @inlinable
    func blue(_ blue: CGFloat) -> ColorFactory<Color> {
        self.edit {
            $0.blue = blue / 255.0
        }
    }
}

#if os(tvOS) || os(iOS) || os(macOS)
public extension ColorFactory {

    @inlinable
    func darkColor(_ color: Color) -> ColorFactory<Color> {
        self.edit {
            $0.darkColor = ColorFactory(color).components
        }
    }

    @inlinable
    func darkColor<DarkColor: ColorType>(_ color: DarkColor) -> ColorFactory<Color> {
        self.edit {
            $0.darkColor = ColorFactory<DarkColor>(color).components
        }
    }

    @inlinable
    func darkColor<Factory: ColorFactoryType>(_ factory: Factory) -> ColorFactory<Color> {
        self.edit {
            $0.darkColor = factory.components
        }
    }
}

public extension ColorFactory {

    @inlinable
    func lightColor(_ color: Color) -> ColorFactory<Color> {
        ColorFactory<Color>(color.components)
            .darkColor(self)
    }

    @inlinable
    func lightColor<LightColor>(_ color: LightColor) -> ColorFactory<LightColor> where LightColor: ColorType {
        ColorFactory<LightColor>(color.components)
            .darkColor(self)
    }

    @inlinable
    func lightColor<Factory>(_ factory: Factory) -> ColorFactory<Factory.Color> where Factory: ColorFactoryType {
        ColorFactory<Factory.Color>(factory.components)
            .darkColor(self)
    }
}
#endif

public extension ColorFactory {
    @inlinable
    func lighter(_ constant: CGFloat) -> ColorFactory<Color> {
        let components = self.components.lighter(with: constant)

        return self.edit {
            $0.red = components.red
            $0.blue = components.blue
            $0.green = components.green
        }
    }

    @inlinable
    func darker(_ constant: CGFloat) -> ColorFactory<Color> {
        let components = self.components.darker(with: constant)

        return self.edit {
            $0.red = components.red
            $0.blue = components.blue
            $0.green = components.green
        }
    }
}

public extension ColorFactory {
    var components: ColorComponents {
        .init(red: self.red, green: self.green, blue: self.blue, alpha: self.alpha)
    }
}

public extension ColorFactory {
    #if os(macOS)
    var nsColor: NSColor {
        let lightColor = self.components
        let darkColor = self.darkColor

        return NSColor(name: nil, dynamicProvider: {
            switch $0.name {
            case .aqua:
                return lightColor.color
            case .darkAqua:
                return darkColor?.color ?? lightColor.color
            default:
                return lightColor.color
            }
        })
    }
    #else
    var uiColor: UIColor {
        let lightColor = self.components

        #if !os(watchOS)
        let darkColor = self.darkColor

        return UIColor(dynamicProvider: {
            switch $0.userInterfaceStyle {
            case .dark:
                return darkColor?.color ?? lightColor.color
            default:
                return lightColor.color
            }
        })
        #else
        return lightColor.color
        #endif

    }
    #endif
    var color: SwiftUI.Color {
        #if os(macOS)
        return SwiftUI.Color(self.nsColor)
        #else
        return SwiftUI.Color(self.uiColor)
        #endif
    }
}
