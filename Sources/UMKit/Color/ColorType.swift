//
//  ColorType.swift
//  UMKit
//
//  Created by brennobemoura on 16/04/20.
//

import Foundation
import UIKit

public protocol ColorType: RawRepresentable, ColorFactoryType where RawValue == String, Color == Self {

}

public extension ColorType {
    static var clear: ColorFactory<Color> {
        .init(.init(red: 0, green: 0, blue: 0, alpha: 0))
    }
}

public extension ColorType {
    var components: UMColor.Components {
        ColorFactory<Color>(self)
            .components
    }
}
