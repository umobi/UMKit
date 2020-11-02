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
public struct Menu: Equatable {
    public let image: Image?
    public let title: Text?
    private let modifierHandler: ((AnyView) -> AnyView)?
    private let isAvailableHandler: (() -> Bool)?

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

    private init(_ original: Menu,_ editable: Editable) {
        self.title = original.title
        self.image = original.image
        self.modifierHandler = editable.modifierHandler
        self.isAvailableHandler = {
            (original.isAvailableHandler?() ?? true) && (editable.isAvailableHandler?() ?? true)
        }
    }

    @usableFromInline
    class Editable {
        @usableFromInline
        var modifierHandler: ((AnyView) -> AnyView)?

        @usableFromInline
        var isAvailableHandler: (() -> Bool)?

        init(_ original: Menu) {
            self.isAvailableHandler = original.isAvailableHandler
            self.modifierHandler = original.modifierHandler
        }
    }

    @inline(__always) @usableFromInline
    func edit(_ edit: (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable)
    }

    @inlinable
    func isAvailable(_ handler: @escaping () -> Bool) -> Self {
        self.edit {
            $0.isAvailableHandler = handler
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

extension Menu {
    @inline(__always) @inlinable
    public static func ==(_ lhs: Menu, _ rhs: Menu) -> Bool {
        lhs.title == rhs.title && lhs.image == rhs.image
    }
}
