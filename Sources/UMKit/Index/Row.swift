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
import UIKit

public extension IndexPath {
    static var zero: IndexPath {
        return .init(row: 0, section: 0)
    }
}

public protocol UMIndexProtocol: Equatable {
    associatedtype Index
    var value: Index? { get }
    var indexPath: IndexPath { get }
    var isSelected: Bool { get }
    
    func select(_ isSelected: Bool) -> Self
    
    init()
}

public extension Equatable where Self: UMIndexProtocol {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.indexPath == rhs.indexPath
    }
}

public extension UMIndexProtocol {
    var item: Index {
        return self.value!
    }
    
    var isEmpty: Bool {
        return self.value == nil
    }
    
    static var empty: Self {
        return .init()
    }
}

public struct UMRow<Index>: UMIndexProtocol {
    public let value: Index?
    public let isSelected: Bool
    
    public let indexPath: IndexPath
    
    public init(_ value: Index, indexPath: IndexPath = .zero) {
        self.value = value
        self.isSelected = false
        self.indexPath = indexPath
    }
    
    public init(selected value: Index, indexPath: IndexPath = .zero) {
        self.value = value
        self.isSelected = true
        self.indexPath = indexPath
    }
    
    public func select(_ isSelected: Bool) -> UMRow<Index> {
        if isSelected {
            return UMRow(selected: self.item, indexPath: self.indexPath)
        }
        
        return UMRow(self.item, indexPath: self.indexPath)
    }
    
    public init() {
        self.value = nil
        self.isSelected = false
        self.indexPath = .zero
    }
}
