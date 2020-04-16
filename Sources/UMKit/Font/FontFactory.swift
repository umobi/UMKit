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
import CoreGraphics
import UIKit

public typealias UMFont = UIFont

public struct FontFactory<Font: FontType> {
    let fontType: Font

    let weight: FontWeight?
    let style: FontStyle?
    let size: CGFloat?
    let bundle: Bundle?
    let filename: String?

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

    private class Editable {
        var weight: FontWeight?
        var style: FontStyle?
        var size: CGFloat?
        var bundle: Bundle?
        var filename: String?

        init(_ maker: FontFactory<Font>) {
            self.weight = maker.weight
            self.style = maker.style
            self.size = maker.size
            self.bundle = maker.bundle
            self.filename = maker.filename
        }
    }

    private func edit(_ edit: @escaping (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }

    public func style(_ style: FontStyle) -> Self {
        self.edit {
            $0.style = style
        }
    }

    public func size(_ size: CGFloat) -> Self {
        self.edit {
            $0.size = size
        }
    }

    public func weight(_ weight: FontWeight) -> Self {
        self.edit {
            $0.weight = weight
        }
    }

    public func bundle(_ bundle: Bundle) -> Self {
        self.edit {
            $0.bundle = bundle
        }
    }

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
    var fontKey: String {
        if let size = self.size {
            return "\(self.fontType.rawValue).w\(self.weight ?? .regular).sized.\(size)"
        }

        guard let style = self.style else {
            fatalError()
        }

        return "\(self.fontType.rawValue).w\(self.weight ?? .regular).styled.\(style)"
    }

    public var font: UMFont? {
        if let font = FontCache.shared[self.fontKey] {
            return font
        }

        if let font = (self.fontType as? FontProvider)?.loadFont(self.frozed) {
            FontCache.shared.addCache(for: self.fontKey, font)
            return font
        }

        if let systemFont = self.fontType as? SystemFont {
            let font = systemFont.loadFont(self.frozed)
            FontCache.shared.addCache(for: self.fontKey, font)
            return systemFont.loadFont(self.frozed)
        }

        FontLoader(self).loadIfNeeded()
        let name = fontName(self.fontType, weight: self.weight)

        guard #available(iOS 11, tvOS 11, watchOS 4, *) else {
            let font = UMFont(name: name, size: self.size ?? UMFont.fontSize)
            FontCache.shared.addCache(for: self.fontKey, font)
            return font
        }

        if let style = self.style {
            let fontMetrics = UIFontMetrics(forTextStyle: style)
            guard let tempFont = UMFont(name: name, size: style.baseSize) else {
                return nil
            }

            let font = fontMetrics.scaledFont(for: tempFont)
            FontCache.shared.addCache(for: self.fontKey, font)
            return font
        }

        let font = UMFont(name: name, size: self.size ?? UMFont.fontSize)
        FontCache.shared.addCache(for: self.fontKey, font)
        return font
    }
}

func fontName<Font: FontType>(_ font: Font, weight: FontWeight?) -> String {
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
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}


public extension UMFont {
    static var fontSize: CGFloat {
        #if os(iOS)
        return UMFont.systemFontSize
        #elseif os(tvOS)
        return 29
        #elseif os(watchOS)
        return 16
        #endif
    }
}
