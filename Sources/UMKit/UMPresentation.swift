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

@usableFromInline
struct UMPresentation<Content>: View where Content: View {
    @usableFromInline
    enum Style {
        case sheet
        #if !os(watchOS) && !os(tvOS)
        case popover
        #endif

        #if !os(macOS)
        @available(iOS 14, tvOS 14, watchOS 7, *)
        case fullScreenCover
        #endif
    }

    @ObservedObject var object: Object

    let content: () -> Content
    let dismissHandler: (() -> Void)?
    let style: Style

    @usableFromInline
    init(_ style: Style, _ isPresented: Binding<Bool>, onDismiss: (() -> Void)?, content: @escaping () -> Content) {
        self.object = .init(isPresented)
        self.content = content
        self.dismissHandler = onDismiss
        self.style = style
    }

    @ViewBuilder @usableFromInline
    var body: some View {
        if !object.isPresented && !object.isTrulyPresented {
            EmptyView()
        } else {
            switch style {
            case .sheet:
                EmptyView()
                    .sheet(isPresented: $object.isTrulyPresented, onDismiss: {
                        object.setPresented(false, isForced: true)
                        dismissHandler?()
                    }, content: dynamicContent)
                
            #if !os(watchOS) && !os(tvOS)
            case .popover:
                EmptyView()
                    .popover(isPresented: $object.isTrulyPresented, content: {
                        dynamicContent()
                            .onDisappear {
                                object.setPresented(false, isForced: true)
                            }
                    })
            #endif

            #if !os(macOS)
            case .fullScreenCover:
                if #available(iOS 14, tvOS 14, watchOS 7, *) {
                    EmptyView()
                        .fullScreenCover(isPresented: $object.isTrulyPresented, onDismiss: {
                            object.setPresented(false, isForced: true)
                            dismissHandler?()
                        }, content: dynamicContent)
                }
            #endif
            }
        }
    }
}

extension UMPresentation {
    class Object: ObservableObject {
        var isTrulyPresented: Bool = false
        @Binding var isPresented: Bool

        init(_ isPresented: Binding<Bool>) {
            self._isPresented = isPresented
        }

        func setPresented(_ flag: Bool, isForced: Bool = false) {
            self.isTrulyPresented = flag

            if isForced {
                self.isPresented = flag
            } else {
                objectWillChange.send()
            }
        }
    }
}

extension UMPresentation {
    var dynamicContent: () -> Content {
        if object.isPresented && !object.isTrulyPresented {
            object.setPresented(true)
        } else if object.isTrulyPresented && !object.isPresented {
            object.setPresented(false)
        }

        return content
    }
}

public extension View {
    @inlinable
    func um_sheet<Content>(
        isPresented: Binding<Bool>,
        content: @escaping () -> Content
    ) -> some View where Content: View {

        self.background(
            UMPresentation(
                .sheet,
                isPresented,
                onDismiss: nil,
                content: content
            )
        )
    }

    @inlinable
    func um_sheet<Content>(
        isPresented: Binding<Bool>,
        onDismiss: @escaping () -> Void,
        content: @escaping () -> Content
    ) -> some View where Content: View {

        self.background(
            UMPresentation(
                .sheet,
                isPresented,
                onDismiss: onDismiss,
                content: content
            )
        )
    }
}

#if !os(watchOS) && !os(tvOS)
public extension View {
    @inlinable
    func um_popover<Content>(
        isPresented: Binding<Bool>,
        content: @escaping () -> Content
    ) -> some View where Content: View {

        self.background(
            UMPresentation(
                .popover,
                isPresented,
                onDismiss: nil,
                content: content
            )
        )
    }
}
#endif


#if !os(macOS)
public extension View {

    @inlinable @available(iOS 14, tvOS 14, watchOS 7, *)
    func um_fullScreenCover<Content>(
        isPresented: Binding<Bool>,
        content: @escaping () -> Content
    ) -> some View where Content: View {

        self.background(
            UMPresentation(
                .fullScreenCover,
                isPresented,
                onDismiss: nil,
                content: content
            )
        )
    }

    @inlinable @available(iOS 14, tvOS 14, watchOS 7, *)
    func um_fullScreenCover<Content>(
        isPresented: Binding<Bool>,
        onDismiss: @escaping () -> Void,
        content: @escaping () -> Content
    ) -> some View where Content: View {

        self.background(
            UMPresentation(
                .fullScreenCover,
                isPresented,
                onDismiss: onDismiss,
                content: content
            )
        )
    }
}
#endif
