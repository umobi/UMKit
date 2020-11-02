//
// Copyright (c) 2020-Present Umobi - https://github.com/umobi
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
public struct FontFactory<Font: FontType> {
    let fontType: Font

    let weight: SwiftUI.Font.Weight?
    let style: SwiftUI.Font.TextStyle?
    let size: CGFloat?
    let bundle: Bundle?
    let filename: String?

    @usableFromInline
    init(font: Font) {
        self.fontType = font
        self.style = nil
        self.size = nil
        self.weight = nil
        self.bundle = nil
        self.filename = nil
    }

    private init(_ original: FontFactory, editable: Editable) {
        self.fontType = original.fontType
        self.style = editable.style
        self.size = editable.size
        self.weight = editable.weight
        self.bundle = editable.bundle
        self.filename = editable.filename
    }

    @usableFromInline
    class Editable {
        @usableFromInline
        var weight: SwiftUI.Font.Weight?

        @usableFromInline
        var style: SwiftUI.Font.TextStyle?

        @usableFromInline
        var size: CGFloat?

        @usableFromInline
        var bundle: Bundle?

        @usableFromInline
        var filename: String?

        init(_ maker: FontFactory<Font>) {
            self.weight = maker.weight
            self.style = maker.style
            self.size = maker.size
            self.bundle = maker.bundle
            self.filename = maker.filename
        }
    }

    @inline(__always) @usableFromInline
    func edit(_ edit: (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }

    @inlinable
    public func style(_ style: SwiftUI.Font.TextStyle) -> Self {
        self.edit {
            $0.style = style
        }
    }

    @inlinable
    public func size(_ size: CGFloat) -> Self {
        self.edit {
            $0.size = size
        }
    }

    @inlinable
    public func weight(_ weight: SwiftUI.Font.Weight) -> Self {
        self.edit {
            $0.weight = weight
        }
    }

    @inlinable
    public func bundle(_ bundle: Bundle) -> Self {
        self.edit {
            $0.bundle = bundle
        }
    }

    @inlinable
    public func filename(_ name: String) -> Self {
        self.edit {
            $0.filename = name
        }
    }

    var frozed: FontFrozen {
        .init(
            fontType: self.fontType.rawValue,
            weight: self.weight,
            style: self.style,
            size: self.size,
            bundle: self.bundle,
            filename: self.filename
        )
    }
}

extension FontFactory {
    public var font: SwiftUI.Font {

        if let font = (self.fontType as? FontProvider)?.loadFont(self.frozed) {
            return font
        }

        if let systemFont = self.fontType as? SystemFont {
            let font = systemFont.loadFont(self.frozed)
            return font
        }

        FontLoader(self).loadIfNeeded()
        let name = fontName(self.fontType, weight: self.weight)

        if let style = self.style {
            if #available(iOS 14, tvOS 14, watchOS 7, *) {
                #if os(iOS) || os(tvOS) || os(watchOS)
                return .custom(name, size: style.baseSize, relativeTo: style)
                #endif
            }

            return .custom(name, size: style.baseSize)
        }

        return .custom(name, size: self.size ?? SwiftUI.Font.TextStyle.body.baseSize)
    }
}

func fontName<Font: FontType>(_ font: Font, weight: SwiftUI.Font.Weight?) -> String {
    let fontName = font.fontName
    let weight: String = {
        if let weight = weight {
            return "\(weight)"
        }

        return "\(font.rawValue.capitalizingFirstLetter())"
    }()

    return "\(fontName)-\(weight)"
}

extension String {
    func capitalizingFirstLetter() -> String {
        prefix(1).uppercased() + lowercased().dropFirst()
    }
}
