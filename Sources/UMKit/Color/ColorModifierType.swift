//
//  ColorModifierType.swift
//  UMKit
//
//  Created by brennobemoura on 16/04/20.
//

import Foundation

public protocol ColorModifierType: ColorFactoryType {
    init(_ color: Color)
    init?(hex: String)

    var components: ColorComponents { get }
}
