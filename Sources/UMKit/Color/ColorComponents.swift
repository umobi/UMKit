//
//  ColorComponents.swift
//  UMKit
//
//  Created by brennobemoura on 16/04/20.
//

import Foundation
import UIKit

public extension UMColor {
    struct Components {
        public let red: CGFloat
        public let green: CGFloat
        public let blue: CGFloat
        public let alpha: CGFloat

        public init(_ color: UMColor) {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0

            color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

            self.red = red
            self.green = green
            self.blue = blue
            self.alpha = alpha
        }

        public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
            self.red = red
            self.green = green
            self.blue = blue
            self.alpha = alpha
        }

        public var hex: String {
            return "#" + ([self.red, self.green, self.blue, self.alpha].reduce("") {
                $0 + String(format: "%02X", Int($1*255))
            })
        }

        public var asColor: UMColor {
            return .init(red: self.red, green: self.green, blue: self.blue, alpha: self.alpha)
        }

        public var isGrayScale: Bool {
            return self.red == self.green && self.green == self.blue
        }

        public init(hash: Int) {
            let red = hash >> 24
            let green = (hash & 0x00ff0000) >> 16
            let blue = (hash & 0x0000ff00) >> 8
            let alpha = (hash & 0x000000ff)

            self.init(UMColor(
                red: CGFloat(red) / 255.0,
                green: CGFloat(green) / 255.0,
                blue: CGFloat(blue) / 255.0,
                alpha: CGFloat(alpha) / 255.0
            ))
        }

        public var hash: Int {
            let blue = Int(self.blue * 255) << 8
            let green = Int(self.green * 255) << 16
            let red = Int(self.red * 255) << 24
            return Int(self.alpha * 255) + blue + green + red
        }
    }

    var components: UMColor.Components {
        return .init(self)
    }
}

public extension UMColor.Components {
    private var maxColorInterval: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        return (1 - self.red, 1 - self.green, 1 - self.blue)
    }

    func lighter(with constant: CGFloat) -> UMColor.Components {
        let max = self.maxColorInterval
        return .init(
            red: self.red + (max.red * constant),
            green: self.green + (max.green * constant),
            blue: self.blue + (max.blue * constant),
            alpha: self.alpha
        )
    }

    func darker(with constant: CGFloat) -> UMColor.Components {
        return .init(
            red: self.red - (self.red * constant),
            green: self.green - (self.green * constant),
            blue: self.blue - (self.blue * constant),
            alpha: self.alpha
        )
    }

    func alpha(constant alpha: CGFloat) -> UMColor.Components {
        return .init(red: self.red, green: self.green, blue: self.blue, alpha: alpha)
    }
}

public extension UMColor.Components {
    static func component(from hex: String) -> UMColor.Components? {
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

    init?(hex: String) {
        guard let component = Self.component(from: hex) else {
            return nil
        }

        self.init(red: component.red, green: component.green, blue: component.blue, alpha: component.alpha)
    }
}

public extension UMColor {
    convenience init?(hex: String) {
        guard let component = Components.component(from: hex) else {
            return nil
        }

        self.init(red: component.red, green: component.green, blue: component.blue, alpha: component.alpha)
    }
}

public extension UMColor.Components {
    var color: UMColor {
        if let color = ColorCache.shared[self.colorKey] {
            return color
        }

        let color = UMColor(red: self.red, green: self.green, blue: self.blue, alpha: self.alpha)
        ColorCache.shared.addCache(for: self.colorKey, color)
        return color
    }
}

extension UMColor.Components {
    var colorKey: String {
        "\(self.red * 255).\(self.green * 255).\(self.blue * 255).\(self.alpha * 100000)"
    }
}
