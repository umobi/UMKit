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

import Foundation
import SwiftUI

@frozen
public struct WindowView<Provider>: SwiftUI.View where Provider: RawWindowProvider {
    @ObservedObject private var settings: WindowSetting<Provider>

    fileprivate var animation: RawWindowAnimation

    public init(_ provider: Provider) {
        self.settings = .init(provider)
        self.animation = CrossFadeWindowAnimation()
    }

    @inline(__always) @usableFromInline
    func edit(_ edit: (inout Self) -> Void) -> Self {
        var mutableSelf = self
        edit(&mutableSelf)
        return mutableSelf
    }

    public var body: some SwiftUI.View {
        self.animation
            .animate(self.settings.provider.view)
            .environmentObject(self.settings)
    }
}

public extension WindowView {
    func animation(_ animation: RawWindowAnimation) -> Self {
        edit {
            $0.animation = animation
        }
    }
}
