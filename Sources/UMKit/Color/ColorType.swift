//
//  ColorType.swift
//  UMKit
//
//  Created by brennobemoura on 16/04/20.
//

import Foundation
import UIKit

protocol ColorType: RawRepresentable, ColorFactoryType where RawValue == String, Color == Self {

}

extension ColorType {
    static var clear: ColorFactory<Color> {
        .init(.init(red: 0, green: 0, blue: 0, alpha: 0))
    }
}

extension ColorType {
    var components: UIColor.Components {
        ColorFactory<Color>(self)
            .components
    }
}
