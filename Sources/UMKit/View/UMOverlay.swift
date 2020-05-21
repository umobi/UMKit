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
fileprivate extension UMOverlay {
    class Settings {
        static var alpha: (CGFloat) -> CGFloat = { _ in 0.16 }
        static var color: UIColor? = UIColor.white
    }
}

open class UMOverlay: UIView {
    private var traitCollectionChanged: ((UMOverlay, UITraitCollection) -> Void)? = nil

    public func setAlpha(_ newValue: CGFloat) {
        self.alpha = newValue
    }

    public func setAlpha(_ dynamic: @escaping (UMOverlay, UITraitCollection) -> Void) {
        self.traitCollectionChanged = dynamic
        self.reload()
    }

    static func orEmpty(_ view: UIView!) -> UMOverlay? {
        return view.subviews.first(where: { $0 is UMOverlay }) as? UMOverlay
    }

    static func orCreate(_ view: UIView!) -> UMOverlay {
        if let view = self.orEmpty(view) {
            return view
        }

        let overlay = Self.init()
        #if os(iOS)
        overlay.isExclusiveTouch = false
        #endif
        overlay.layer.zPosition = -1
        overlay.translatesAutoresizingMaskIntoConstraints = false

        view.insertSubview(overlay, at: 0)

        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: view.topAnchor),
            overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        overlay.backgroundColor = Self.Settings.color
        overlay.layer.cornerRadius = view.layer.cornerRadius
        overlay.isOpaque = false
        overlay.reload()

        return overlay
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.reload()
    }

    private func reload() {
        if let traitCollectionChanged = self.traitCollectionChanged {
            traitCollectionChanged(self, self.traitCollection)
            let alpha = Self.Settings.alpha(self.alpha)
            self.alpha = alpha
            return
        }
    }
}

@objc public extension UIView {
    @IBInspectable
    var isOverlayHidden: Bool {
        get {
            return UMOverlay.orEmpty(self) == nil
        }

        set {
            if newValue {
                UMOverlay.orEmpty(self)?.removeFromSuperview()
            } else {
                _ = UMOverlay.orCreate(self)
            }
        }
    }

    @IBInspectable
    var overlayAlpha: CGFloat {
        get {
            return UMOverlay.orEmpty(self)?.alpha ?? 0
        }

        set {
            (newValue > 0 ? UMOverlay.orCreate(self) : UMOverlay.orEmpty(self))?.setAlpha(newValue)
        }
    }

    @IBInspectable
    var overlayColor: UIColor? {
        get {
            return UMOverlay.orEmpty(self)?.backgroundColor
        }

        set {
            UMOverlay.orCreate(self).backgroundColor = newValue
        }
    }

    var overlay: UMOverlay? {
        return UMOverlay.orEmpty(self)
    }
}

public extension UIView {
    static var overlayAlpha: (CGFloat) -> CGFloat {
        get {
            return UMOverlay.Settings.alpha
        }

        set {
            UMOverlay.Settings.alpha = newValue
        }
    }

    static var overlayColor: UIColor? {
        get {
            return UMOverlay.Settings.color
        }

        set {
            UMOverlay.Settings.color = newValue
        }
    }
}

public extension UMOverlay {
    static func defaultLayout(backgroundColor: UIColor) {
        let alphas = (self.zeroTilFiveAlpha + self.sixTilTwelveAlpha + self.thirteenTilTwentyFourAlpha)
        UIView.overlayColor = backgroundColor
        UIView.overlayAlpha = { alpha in
            alphas.first(where: {
                $0.0 == Int(alpha)
            })?.1 ?? 0.0
        }
    }

    private static var zeroTilFiveAlpha: [(Int, CGFloat)] {
        return [
            (1, 0.05),
            (2, 0.07),
            (3, 0.08),
            (4, 0.09),
            (5, 0.1)
        ]
    }

    private static var sixTilTwelveAlpha: [(Int, CGFloat)] {
        return (6 ... 12).enumerated().map {
            ($0.element, 0.11 + (CGFloat($0.offset) * 0.005))
        }
    }

    private static var thirteenTilTwentyFourAlpha: [(Int, CGFloat)] {
        let array = (12 ... 24).map { $0 }
        return Array((array.enumerated().map {
            ($0.element, 0.14 + (CGFloat($0.offset) * (0.01 / CGFloat(array.count - 1))))
        })[1..<array.count])
    }
}
#endif
