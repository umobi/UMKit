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

public typealias FontStyle = UMFont.TextStyle

#if os(iOS)
extension FontStyle: FontStyleSized {
    public var baseSize: CGFloat {
        return ({
            if #available(iOS 11.0, *) {
                switch self {
                case .largeTitle:
                    return 36.0
                default:
                    return nil
                }
            }
            return nil
        }() as CGFloat?) ?? {
            switch self {
            case .title1:
                return 32.0
            case .title2:
                return 28.0
            case .title3:
                return 21.0
            case .headline:
                return 17.0
            case .subheadline:
                return 15.0
            case .body:
                return 17.0
            case .callout:
                return 16.0
            case .footnote:
                return 13.0
            case .caption1:
                return 12.0
            case .caption2:
                return 11.0
            default:
                return UMFont.fontSize
            }
        }()
    }
}
#endif

#if os(tvOS)
extension FontStyle: FontStyleSized {
    public var baseSize: CGFloat {
        switch self {
        case .title1:
            return 76.0
        case .title2:
            return 57.0
        case .title3:
            return 48.0
        case .headline:
            return 38.0
        case .subheadline:
            return 35.0     // NOT FOUND
        case .body:
            return 29.0
        case .callout:
            return 31.0
        case .footnote:
            return 27.0     // NOT FOUND
        case .caption1:
            return 25.0
        case .caption2:
            return 23.0
        default:
            return UMFont.fontSize
        }
    }
}
#endif

#if os(watchOS)
extension FontStyle: FontStyleSized {
    public var baseSize: CGFloat {
        return ({
            if #available(watchOS 5.0, *) {
                switch self {
                case .largeTitle:
                    return 36.0
                default:
                    return nil
                }
            }
            return nil
        }() as CGFloat?) ?? {
            switch self {
            case .title1:
                return 34.0
            case .title2:
                return 27.0
            case .title3:
                return 19.0
            case .headline:
                return 16.0
            case .subheadline:
                return 16.0     // NOT FOUND
            case .body:
                return 16.0
            case .callout:
                return 16.0
            case .footnote:
                return 13.0     // NOT FOUND
            case .caption1:
                return 15.0
            case .caption2:
                return 14.0
            default:
                return UMFont.fontSize
            }
        }()
    }
}
#endif
