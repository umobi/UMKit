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
public struct UMSection<Section, Item> {
    public let section: Section
    public let items: [Item]
    public let index: Int

    @inlinable
    public init(_ section: Section, items: [Item], section index: Int = 0) {
        self.section = section
        self.items = items
        self.index = index
    }

    @inlinable
    public var asSectionRows: [UMSectionRow<Section, Item>] {
        self.items
            .enumerated()
            .compactMap {
                UMSectionRow(
                    self,
                    row: .init(
                        $0.1,
                        indexPath: .init(
                            row: $0.0,
                            section: self.index
                        )
                    )
                )
        }
    }
}

@frozen
public struct UMSectionRow<Index, IndexRow>: UMIndexProtocol {
    public let value: UMSection<Index, IndexRow>?
    public let row: UMRow<IndexRow>

    @inlinable
    public init(_ section: UMSection<Index, IndexRow>, row: UMRow<IndexRow>) {
        self.value = section
        self.row = row
    }

    @inline(__always) @inlinable
    public var indexPath: UMIndexPath {
        self.row.indexPath
    }

    @inline(__always) @inlinable
    public var isSelected: Bool {
        self.row.isSelected
    }

    @inlinable
    public func select(_ isSelected: Bool) -> UMSectionRow<Index, IndexRow> {
        UMSectionRow(self.item, row: self.row.select(isSelected))
    }

    @inlinable
    public init() {
        self.value = nil
        self.row = .empty
    }
}

extension UMSectionRow where IndexRow: Equatable {
    @inlinable
    public var isFirst: Bool {
        guard let first = self.item.items.first else {
            return self.indexPath.row == 0
        }

        guard let value = row.value else {
            return self.indexPath.row == 0
        }

        return first == value
    }

    @inlinable
    public var isLast: Bool {
        guard let last = self.item.items.last else {
            return self.indexPath.row == self.item.items.count - 1
        }

        guard let value = row.value else {
            return self.indexPath.row == self.item.items.count - 1
        }

        return last == value
    }
}

public protocol SectionDataSource {
    associatedtype Item
    var items: [Item] { get }
    var asSection: UMSection<Self, Item> { get }

    func asSection(with index: Int) -> UMSection<Self, Item>
}

public extension SectionDataSource {
    @inline(__always) @inlinable
    var asSection: UMSection<Self, Item> {
        .init(self, items: self.items)
    }

    @inline(__always) @inlinable
    func asSection(with index: Int) -> UMSection<Self, Item> {
        .init(self, items: self.items, section: index)
    }
}

public extension Array where Element: SectionDataSource {
    @inline(__always) @inlinable
    func asSection() -> [UMSection<Element, Element.Item>] {
        self.enumerated().compactMap { $0.1.asSection(with: $0.0) }
    }

    @inline(__always) @inlinable
    func asSectionRow() -> [[UMSectionRow<Element, Element.Item>]] {
        self.asSection().compactMap { $0.asSectionRows }
    }
}
