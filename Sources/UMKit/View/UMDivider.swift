//
// Copyright (c) 2019-Present Umobi - https://github.com/umobi
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

public enum UMDividerDirection {
    case top
    case left
    case right
    case bottom
}

public struct UMDividerPadding {
    let leftOrTop: CGFloat
    let rightOrBottom: CGFloat

    init(_ leftOrTop: CGFloat, _ rightOrBottom: CGFloat) {
        self.leftOrTop = leftOrTop
        self.rightOrBottom = rightOrBottom
    }

    static var zero: UMDividerPadding {
        .init(.zero, .zero)
    }
}

private struct UMDivider<Content>: View where Content: View {
    let direction: UMDividerDirection
    let content: () -> Content
    let color: Color
    let padding: UMDividerPadding
    let height: CGFloat
    @Environment(\.layoutDirection) var layoutDirection

    init(_ color: Color, _ direction: UMDividerDirection, _ padding: UMDividerPadding, _ height: CGFloat, _ content: @escaping () -> Content) {
        self.content = content
        self.direction = direction
        self.color = color
        self.padding = padding
        self.height = height
    }

    var verticalColor: AnyView {
        AnyView(
            self.color
                .frame(width: self.height, height: .infinity)
                .padding(
                    EdgeInsets(
                        top: self.padding.leftOrTop,
                        leading: .zero,
                        bottom: self.padding.rightOrBottom,
                        trailing: .zero
                    )
                )
        )
    }

    var horizontalColor: AnyView {
        AnyView(
            self.color
                .padding(
                    EdgeInsets(
                        top: .zero,
                        leading: self.padding.leftOrTop,
                        bottom: .zero,
                        trailing: self.padding.rightOrBottom
                    )
                )
                .frame(maxWidth: .infinity, idealHeight: self.height)
        )
    }

    var body: some View {
        switch self.direction {
        case .top, .bottom:
            VStack(spacing: .zero) {
                if case .top = self.direction {
                    self.horizontalColor
                }

                self.content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                if case .bottom = self.direction {
                    self.horizontalColor
                }
            }
        case .left, .right:
            HStack(spacing: .zero) {
                if self.direction.isLeft(self.layoutDirection) {
                    self.verticalColor
                }

                self.content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                if self.direction.isRight(self.layoutDirection) {
                    self.verticalColor
                }
            }
        }
    }
}

private extension UMDividerDirection {
    func isLeft(_ layoutDirection: LayoutDirection) -> Bool {
        switch layoutDirection {
        case .leftToRight:
            return self == .left
        case .rightToLeft:
            return self == .right
        @unknown default:
            return self == .left
        }
    }

    func isRight(_ layoutDirection: LayoutDirection) -> Bool {
        switch layoutDirection {
        case .leftToRight:
            return self == .right
        case .rightToLeft:
            return self == .left
        @unknown default:
            return self == .right
        }
    }
}

public extension View {
    func umDivider(color: Color, direction: UMDividerDirection) -> AnyView {
        AnyView(UMDivider(color, direction, .zero, 1, { self }))
    }

    func umDivider(color: Color, height: CGFloat, direction: UMDividerDirection) -> AnyView {
        AnyView(UMDivider(color, direction, .zero, height, { self }))
    }

    func umDivider(color: Color, direction: UMDividerDirection, padding: UMDividerPadding) -> AnyView {
        AnyView(UMDivider(color, direction, padding, 1, { self }))
    }

    func umDivider(color: Color, height: CGFloat, direction: UMDividerDirection, padding: UMDividerPadding) -> AnyView {
        AnyView(UMDivider(color, direction, padding, height, { self }))
    }
}
