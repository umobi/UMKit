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

@frozen
public struct UMIndexPath: Equatable {
    public let row: Int
    public let section: Int

    @inlinable
    public init(row: Int, section: Int) {
        self.row = row
        self.section = section
    }

    @inline(__always) @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.row == rhs.row && lhs.section == rhs.section
    }
}

public extension UMIndexPath {
    @inline(__always) @inlinable
    static var zero: UMIndexPath {
        .init(row: 0, section: 0)
    }
}

public protocol UMIndexProtocol: Equatable {
    associatedtype Index
    var value: Index? { get }
    var indexPath: UMIndexPath { get }
    var isSelected: Bool { get }

    func select(_ isSelected: Bool) -> Self

    init()
}

public extension Equatable where Self: UMIndexProtocol {
    @inline(__always) @inlinable
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.indexPath == rhs.indexPath
    }
}

public extension UMIndexProtocol {
    @inline(__always) @inlinable
    var item: Index {
        self.value!
    }

    @inline(__always) @inlinable
    var isEmpty: Bool {
        self.value == nil
    }

    @inline(__always) @inlinable
    static var empty: Self {
        .init()
    }
}

@frozen
public struct UMRow<Index>: UMIndexProtocol {
    public let value: Index?
    public let isSelected: Bool

    public let indexPath: UMIndexPath

    @inlinable
    public init(_ value: Index, indexPath: UMIndexPath = .zero) {
        self.value = value
        self.isSelected = false
        self.indexPath = indexPath
    }

    @inlinable
    public init(selected value: Index, indexPath: UMIndexPath = .zero) {
        self.value = value
        self.isSelected = true
        self.indexPath = indexPath
    }

    @inlinable
    public func select(_ isSelected: Bool) -> UMRow<Index> {
        if isSelected {
            return UMRow(selected: self.item, indexPath: self.indexPath)
        }

        return UMRow(self.item, indexPath: self.indexPath)
    }

    @inlinable
    public init() {
        self.value = nil
        self.isSelected = false
        self.indexPath = .zero
    }
}
