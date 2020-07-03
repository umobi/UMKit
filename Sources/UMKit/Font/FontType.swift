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

/**
    The name of fonts should be FontName-Weight.tff
    A regular Roboto font may be RobotoFont-Regular.tff
    It can be used the FontProvider to load fonts.
*/
public protocol FontType: RawRepresentable where RawValue == String {
}

extension FontType {
    var fontName: String {
        "\(type(of: self))"
    }
}

public extension FontType {
    func style(_ style: Font.TextStyle) -> FontFactory<Self> {
        FontFactory(font: self)
            .style(style)
    }

    func size(_ size: CGFloat) -> FontFactory<Self> {
        FontFactory(font: self)
            .size(size)
    }
}
