//
//  ColorModifierType.swift
//  UMKit
//
//  Created by brennobemoura on 16/04/20.
//

import Foundation
import UIKit

protocol ColorModifierType: ColorFactoryType {
    var components: UIColor.Components { get }
}
