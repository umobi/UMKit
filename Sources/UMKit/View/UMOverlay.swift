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

private struct Overlay<Modifier>: View where Modifier : OverlayModifier {
    @Environment(\.colorScheme) var colorScheme
    let color: Color
    let modifier: Modifier

    init(_ color: Color,_ modifier: Modifier) {
        self.color = color
        self.modifier = modifier
    }

    var body: some View {
        self.modifier.colorScheme(self.color, self.colorScheme)
    }
}

public protocol OverlayModifier {
    func colorScheme(_ color: Color, _ colorScheme: ColorScheme) -> Color
}

private struct OverlayDefaultModifier: OverlayModifier {
    func colorScheme(_ color: Color, _ colorScheme: ColorScheme) -> Color {
        color
    }
}

public extension View {
    @inline(__always)
    func umOverlay(_ color: Color) -> some View {
        self.background(Overlay(color, OverlayDefaultModifier()))
    }

    @inline(__always)
    func umOverlay<Modifier>(_ color: Color, _ modifier: Modifier) -> some View where Modifier: OverlayModifier {
        self.background(Overlay(color, modifier))
    }
}
