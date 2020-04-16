//
//  ColorFactory.swift
//  UMKit
//
//  Created by brennobemoura on 16/04/20.
//

import Foundation
import UIKit

struct ColorFactory<Color: ColorType>: ColorFactoryType {
    let alpha: CGFloat
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let darkColor: UIColor.Components?

    init(_ color: Color) {
        guard let components = UIColor.Components.component(from: color.rawValue) else {
            fatalError()
        }

        self.alpha = components.alpha
        self.red = components.red
        self.green = components.green
        self.blue = components.blue
        self.darkColor = nil
    }

    init(_ components: UIColor.Components) {
        self.alpha = components.alpha
        self.red = components.red
        self.green = components.green
        self.blue = components.blue
        self.darkColor = nil
    }

    private init(_ original: ColorFactory<Color>, editable: Editable) {
        self.alpha = editable.alpha
        self.red = editable.red
        self.green = editable.green
        self.blue = editable.blue
        self.darkColor = editable.darkColor
    }

    fileprivate func edit(_ edit: @escaping (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }

    fileprivate class Editable {
        var alpha: CGFloat
        var red: CGFloat
        var green: CGFloat
        var blue: CGFloat
        var darkColor: UIColor.Components?

        init(_ colorFactory: ColorFactory<Color>) {
            self.alpha = colorFactory.alpha
            self.red = colorFactory.red
            self.green = colorFactory.green
            self.blue = colorFactory.blue
            self.darkColor = colorFactory.darkColor
        }
    }
}

extension ColorFactory {
    func alpha(_ alpha: CGFloat) -> Self {
        self.edit {
            $0.alpha = alpha
        }
    }

    func red(_ red: CGFloat) -> ColorFactory<Color> {
        self.edit {
            $0.red = red / 255.0
        }
    }

    func green(_ green: CGFloat) -> ColorFactory<Color> {
        self.edit {
            $0.green = green / 255.0
        }
    }

    func blue(_ blue: CGFloat) -> ColorFactory<Color> {
        self.edit {
            $0.blue = blue / 255.0
        }
    }
}

#if os(tvOS) || os(iOS)
extension ColorFactory {

    func darkColor(_ color: Color) -> ColorFactory<Color> {
        self.edit {
            $0.darkColor = ColorFactory(color).components
        }
    }

    func darkColor<DarkColor: ColorType>(_ color: DarkColor) -> ColorFactory<Color> {
        self.edit {
            $0.darkColor = ColorFactory<DarkColor>(color).components
        }
    }

    func darkColor<Factory: ColorFactoryType>(_ factory: Factory) -> ColorFactory<Color> {
        self.edit {
            $0.darkColor = factory.components
        }
    }
}

extension ColorFactory {

    func lightColor(_ color: Color) -> ColorFactory<Color> {
        ColorFactory<Color>(color.components)
            .darkColor(self)
    }

    func lightColor<LightColor>(_ color: LightColor) -> ColorFactory<LightColor> where LightColor : ColorType {
        ColorFactory<LightColor>(color.components)
            .darkColor(self)
    }

    func lightColor<Factory>(_ factory: Factory) -> ColorFactory<Factory.Color> where Factory : ColorFactoryType {
        ColorFactory<Factory.Color>(factory.components)
            .darkColor(self)
    }
}
#endif

extension ColorFactory {
    func lighter(_ constant: CGFloat) -> ColorFactory<Color> {
        let components = self.components.lighter(with: constant)

        return self.edit {
            $0.red = components.red
            $0.blue = components.blue
            $0.green = components.green
        }
    }

    func darker(_ constant: CGFloat) -> ColorFactory<Color> {
        let components = self.components.darker(with: constant)

        return self.edit {
            $0.red = components.red
            $0.blue = components.blue
            $0.green = components.green
        }
    }
}

extension ColorFactory {
    var components: UIColor.Components {
        .init(red: self.red, green: self.green, blue: self.blue, alpha: self.alpha)
    }
}

extension ColorFactory {
    var color: UIColor {
        let lightColor = self.components.color

        #if os(iOS) || os(tvOS)
            guard let darkColor = self.darkColor?.color, #available(iOS 13, tvOS 13, *) else {
                return lightColor
            }

            return .init(dynamicProvider: {
                switch $0.userInterfaceStyle {
                case .dark:
                    return darkColor
                default:
                    return lightColor
                }
            })
        #else
            return lightColor
        #endif
    }
}
