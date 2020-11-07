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

@frozen
public struct UMMenu: Equatable {
    public let image: Image?
    public let title: Text?

    @usableFromInline
    var modifierHandler: ((AnyView) -> AnyView)?

    @usableFromInline
    var isAvailableHandler: (() -> Bool)?

    @inline(__always)
    public var isAvailable: Bool {
        self.isAvailableHandler?() ?? true
    }

    public init(_ title: Text) {
        self.title = title
        self.image = nil
        self.modifierHandler = nil
        self.isAvailableHandler = nil
    }

    public init(_ image: Image) {
        self.image = image
        self.title = nil
        self.modifierHandler = nil
        self.isAvailableHandler = nil
    }

    public init(_ image: Image, _ title: Text) {
        self.image = image
        self.title = title
        self.modifierHandler = nil
        self.isAvailableHandler = nil
    }

    @inline(__always) @usableFromInline
    func edit(_ edit: (inout Self) -> Void) -> Self {
        var mutableSelf = self
        edit(&mutableSelf)
        return mutableSelf
    }
}

public extension UMMenu {
    @inlinable
    func isAvailable(_ handler: @escaping () -> Bool) -> Self {
        self.edit {
            $0.isAvailableHandler = {
                (self.isAvailableHandler?() ?? true) && handler()
            }
        }
    }

    @inlinable
    func onModify(_ handler: @escaping (AnyView) -> AnyView) -> Self {
        self.edit {
            $0.modifierHandler = handler
        }
    }

    func modify<Content>(_ view: Content) -> AnyView where Content: View {
        if let modifierHandler = modifierHandler {
            return modifierHandler(AnyView(view))
        }

        return AnyView(view)
    }
}

public extension UMMenu {
    @inline(__always) @inlinable
    static func ==(_ lhs: UMMenu, _ rhs: UMMenu) -> Bool {
        lhs.title == rhs.title && lhs.image == rhs.image
    }
}
