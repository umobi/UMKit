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

extension Menu {
    public struct PresentView<Destination>: View where Destination: View {
        @State private var isPresenting: Bool = false

        private let destination: (Binding<Bool>) -> Destination
        private let content: (Binding<Bool>) -> AnyView

        public init<Content>(destination: @escaping (Binding<Bool>) -> Destination, content: Content) where Content: View {
            self.destination = destination
            self.content = { isPresenting in
                {
                    #if !os(tvOS)
                    return AnyView(content.onTapGesture {
                        isPresenting.wrappedValue = true
                    })
                    #else
                    return AnyView(content)
                    #endif
                }()
            }
        }

        public var body: some View {
            content($isPresenting)
                .sheet(isPresented: $isPresenting, content: {
                    destination($isPresenting)
                })
        }
    }
}
