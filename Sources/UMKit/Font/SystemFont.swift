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

import SwiftUI

public enum SystemFont: String, FontType {
    case bold
    case regular
    case thin
    case medium
}

extension SystemFont {
    var weight: Font.Weight {
        switch self {
        case .bold:
            return .bold
        case .regular:
            return .regular
        case .thin:
            return .thin
        case .medium:
            return .medium
        }
    }

    func loadFont(_ fontMaker: FontFrozen) -> Font {
        guard let this = SystemFont(rawValue: fontMaker.fontType) else {
            fatalError()
        }

        if let size = fontMaker.size {
            return Font.system(size: size, weight: fontMaker.weight ?? this.weight, design: .default)
        }

        guard let style = fontMaker.style else {
            fatalError()
        }

        return Font.system(style)
            .weight(self.weight)
    }
}
