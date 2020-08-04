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
import CoreText

struct FontLoader<Font: FontType> {
    private let maker: FontFactory<Font>

    init(_ maker: FontFactory<Font>) {
        self.maker = maker
    }

    private var filename: String {
        if let filename = self.maker.filename {
            return filename
        }

        return "\(fontName(self.maker.fontType, weight: self.maker.weight))"
    }

    func loadIfNeeded() {
        let bundle = maker.bundle ?? .main
        var errorRef: Unmanaged<CFError>?
        let filename = self.filename

        guard
            !FontLoaded.shared.isFontLoaded(filename),
            let pathForResource = (kFontType.compactMap {
                bundle.path(forResource: filename, ofType: $0)
            }.first),
            let fontData = NSData(contentsOfFile: pathForResource),
            let dataProvider = CGDataProvider(data: fontData),
            let fontRef = CGFont(dataProvider),
            CTFontManagerRegisterGraphicsFont(fontRef, &errorRef)
            else {
                return
            }

        FontLoaded.shared.store(filename)
    }
}

private var kFontType: [String] {
    ["ttf", "otf"]
}
