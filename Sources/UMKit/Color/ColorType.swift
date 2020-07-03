//
//  ColorType.swift
//  UMKit
//
//  Created by brennobemoura on 16/04/20.
//

import Foundation

public protocol ColorType: RawRepresentable, ColorFactoryType where RawValue == String, Color == Self {

}

public extension ColorType {
    static var clear: ColorFactory<Color> {
        .init(.init(red: 0, green: 0, blue: 0, alpha: 0))
    }
}

public extension ColorType {
    var components: ColorComponents {
        ColorFactory<Color>(self)
            .components
    }
}
