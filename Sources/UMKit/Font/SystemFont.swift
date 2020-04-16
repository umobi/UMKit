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
import UIKit

enum SystemFont: String, FontType {
    case bold
    case regular
    case thin
}

extension SystemFont {
    var weight: FontWeight {
        switch self {
        case .bold:
            return .bold
        case .regular:
            return .regular
        case .thin:
            return .thin
        }
    }

    func loadFont(_ fontMaker: FontFrozen) -> UIFont? {
        guard let this = SystemFont(rawValue: fontMaker.fontType) else {
            return nil
        }

        if let size = fontMaker.size {
            return UIFont.systemFont(ofSize: size, weight: fontMaker.weight ?? this.weight)
        }

        let font = UIFont.systemFont(ofSize: fontMaker.size ?? fontMaker.style?.baseSize ?? UIFont.systemFontSize, weight: fontMaker.weight ?? this.weight)

        guard #available(iOS 11, *), let style = fontMaker.style else {
            return font
        }

        let metrics = UIFontMetrics(forTextStyle: style)
        return metrics.scaledFont(for: font)
    }
}
