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

@frozen
public struct ColorComponents {
    public let red: CGFloat
    public let green: CGFloat
    public let blue: CGFloat
    public let alpha: CGFloat

    @inlinable
    public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    @inlinable
    public var hex: String {
        [red, green, blue, alpha].reduce("#") {
            $0 + String(format: "%02X", Int($1*255))
        }
    }

    @inline(__always) @inlinable
    public var isGrayScale: Bool {
        self.red == self.green && self.green == self.blue
    }
}

public extension ColorComponents {
    // swiftlint:disable large_tuple
    @inline(__always)
    private var maxColorInterval: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        (1 - self.red, 1 - self.green, 1 - self.blue)
    }

    func lighter(with constant: CGFloat) -> ColorComponents {
        let max = self.maxColorInterval

        return .init(
            red: self.red + (max.red * constant),
            green: self.green + (max.green * constant),
            blue: self.blue + (max.blue * constant),
            alpha: self.alpha
        )
    }

    @inlinable
    func darker(with constant: CGFloat) -> ColorComponents {
        .init(
            red: self.red - (self.red * constant),
            green: self.green - (self.green * constant),
            blue: self.blue - (self.blue * constant),
            alpha: self.alpha
        )
    }

    @inline(__always) @inlinable
    func alpha(constant alpha: CGFloat) -> ColorComponents {
        .init(red: self.red, green: self.green, blue: self.blue, alpha: alpha)
    }
}

public extension ColorComponents {
    @inlinable
    static func component(from hex: String) -> ColorComponents? {
        guard hex.hasPrefix("#") && hex.count >= 7 else {
            return nil
        }

        let colorString: String = {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let end = hex.index(hex.startIndex, offsetBy: 7)
            return String(hex[start..<end])
        }()

        let alphaString: String = {
            guard hex.count == 9 else {
                return "FF"
            }

            let start = hex.index(hex.startIndex, offsetBy: 7)

            return String(hex[start...])
        }()

        let alpha: CGFloat = {
            let scanner = Scanner(string: alphaString)
            var hexNumber: UInt64 = 0

            guard scanner.scanHexInt64(&hexNumber) else {
                return 1
            }

            return CGFloat(hexNumber & 0xff) / 255
        }()

        guard let components: (red: CGFloat, green: CGFloat, blue: CGFloat) = ({
            let scanner = Scanner(string: colorString)
            var hexNumber: UInt64 = 0

            guard scanner.scanHexInt64(&hexNumber) else {
                return nil
            }

            return (
                red: CGFloat((hexNumber & 0xff0000) >> 16) / 255,
                green: CGFloat((hexNumber & 0x00ff00) >> 8) / 255,
                blue: CGFloat((hexNumber & 0x0000ff)) / 255
            )
        }()) else { return nil }

        return .init(red: components.red, green: components.green, blue: components.blue, alpha: alpha)
    }

    @inlinable
    init?(hex: String) {
        guard let component = Self.component(from: hex) else {
            return nil
        }

        self.init(red: component.red, green: component.green, blue: component.blue, alpha: component.alpha)
    }
}

extension ColorComponents {
    var colorKey: String {
        "\(self.red * 255).\(self.green * 255).\(self.blue * 255).\(self.alpha * 100000)"
    }
}

#if os(macOS)
import AppKit

extension ColorComponents {
    var color: NSColor {
        .init(red: self.red, green: self.green, blue: self.blue, alpha: self.alpha)
    }
}
#else
import UIKit

extension ColorComponents {
    var color: UIColor {
        .init(red: self.red, green: self.green, blue: self.blue, alpha: self.alpha)
    }
}
#endif
