//
//  ColorFactoryType.swift
//  UMKit
//
//  Created by brennobemoura on 16/04/20.
//

import Foundation
import UIKit

public typealias UMColor = UIColor

public protocol ColorFactoryType {
    associatedtype Color: ColorType

    var color: UMColor { get }
    var components: UMColor.Components { get }

    func lighter(_ constant: CGFloat) -> ColorFactory<Color>
    func darker(_ constant: CGFloat) -> ColorFactory<Color>

    #if os(iOS) || os(tvOS)
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

#if os(iOS) || os(tvOS)
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

    func lightColor<LightColor>(_ color: LightColor) -> ColorFactory<LightColor> where LightColor : ColorType {
        ColorFactory<LightColor>(self.components)
            .lightColor(color)
    }

    func lightColor<Factory>(_ factory: Factory) -> ColorFactory<Factory.Color> where Factory : ColorFactoryType {
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
    var color: UMColor {
        ColorFactory<Color>(self.components)
            .color
    }
}
