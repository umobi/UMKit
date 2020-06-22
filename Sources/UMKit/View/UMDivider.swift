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

#if !os(watchOS)
private var kDivider = 0
private extension UIView {
    var divider: UMDivider? {
        get { objc_getAssociatedObject(self, &kDivider) as? UMDivider }
        set { objc_setAssociatedObject(self, &kDivider, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
}

public class UMDivider: UIView {

    fileprivate static func orEmpty(view: UIView) -> UMDivider? {
        view.divider
    }

    fileprivate static func orCreate(view: UIView) -> UMDivider {
        if let divider = UMDivider.orEmpty(view: view) {
            return divider
        }

        let divider = UMDivider()
        divider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(divider)

        divider.reloadLayout()

        view.divider = divider

        return divider
    }

    public var thickness: CGFloat = 1 {
        didSet {
            self.reloadLayout()
        }
    }

    public var alignment: Alignment = .bottom {
        didSet {
            self.reloadLayout()
        }
    }

    /// A reference to EdgeInsets.
    public var insets: UIEdgeInsets = .zero {
        didSet {
            self.reloadLayout()
        }
    }

    /// Lays out the divider.
    func reloadLayout() {
        guard let superview = self.superview else {
            return
        }

        self.removeFromSuperview()
        NSLayoutConstraint.deactivate(self.constraints)
        superview.addSubview(self)
        self.layer.zPosition = 5000

        self.aligment(self.alignment, in: superview)
    }
}

public extension UMDivider {
    enum Alignment {
        case top
        case left
        case bottom
        case right
    }

    func topLayout(_ superview: UIView) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: self.insets.top),
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: self.insets.left),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -self.insets.right),
            self.heightAnchor.constraint(equalToConstant: self.thickness)
        ])
    }

    func leftLayout(_ superview: UIView) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: self.insets.top),
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: self.insets.left),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -self.insets.bottom),
            self.widthAnchor.constraint(equalToConstant: self.thickness)
        ])
    }

    func bottomLayout(_ superview: UIView) {
        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -self.insets.bottom),
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: self.insets.left),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -self.insets.right),
            self.heightAnchor.constraint(equalToConstant: self.thickness)
        ])
    }

    func rightLayout(_ superview: UIView) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: self.insets.top),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -self.insets.bottom),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -self.insets.right),
            self.widthAnchor.constraint(equalToConstant: self.thickness)
        ])
    }

    func aligment(_ aligment: Alignment, in superview: UIView) {
        switch aligment {
        case .top:
            self.topLayout(superview)
        case .left:
            self.leftLayout(superview)
        case .right:
            self.rightLayout(superview)
        case .bottom:
            self.bottomLayout(superview)
        }
    }
}

public extension UIView {

    var dividerAlignment: UMDivider.Alignment {
        get {
            return UMDivider.orEmpty(view: self)?.alignment ?? .bottom
        }
        set {
            UMDivider.orCreate(view: self).alignment = newValue
        }
    }

    var dividerColor: UIColor? {
        get {
            return UMDivider.orEmpty(view: self)?.backgroundColor
        }
        set {
            UMDivider.orCreate(view: self).backgroundColor = newValue
        }
    }

    var isDividerHidden: Bool {
        get {
            return UMDivider.orEmpty(view: self) == nil
        }
        set {
            if newValue {
                UMDivider.orEmpty(view: self)?.isHidden = true
                return
            }
            UMDivider.orCreate(view: self).isHidden = false
        }
    }

    var dividerThickness: CGFloat {
        get {
            return UMDivider.orEmpty(view: self)?.thickness ?? 0.0
        }
        set {
            guard newValue > 0 else {
                UMDivider.orEmpty(view: self)?.isHidden = true
                return
            }
            UMDivider.orCreate(view: self).thickness = newValue
        }
    }

    var dividerInsets: UIEdgeInsets {
        get {
            return UMDivider.orEmpty(view: self)?.insets ?? .zero
        }
        set {
            UMDivider.orCreate(view: self).insets = newValue
        }
    }

    var dividerAlpha: CGFloat {
        get {
            return UMDivider.orEmpty(view: self)?.alpha ?? .zero
        }
        set {
            guard newValue > 0 else {
                UMDivider.orEmpty(view: self)?.alpha = newValue
                return
            }

            UMDivider.orCreate(view: self).alpha = newValue
        }
    }
}
#endif
