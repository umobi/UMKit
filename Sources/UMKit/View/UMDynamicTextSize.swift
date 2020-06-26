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
public class UMDynamicTextSize: UIView {
    private weak var label: UILabel!
    fileprivate var textValueObserver: NSKeyValueObservation!
    fileprivate var numberOfLinesObserver: NSKeyValueObservation!
    fileprivate var hyphenFactor: CGFloat = 0

    private var limitContentSize: UIContentSizeCategory?

    public var overrideMinimumScaleFactor: CGFloat?
    public var overrideAdjustsFontSizeToFitWidth: Bool?

    var isMultilineText: Bool {
        if self.label is UMLineLabel {
            return false
        }

        if self.label is UMMultilineLabel {
            return true
        }

        return self.label?.numberOfLines ?? 1 != 1
    }

    private init(_ label: UILabel) {
        super.init(frame: .zero)

        self.label = label
        self.label.adjustsFontForContentSizeCategory = true
//        label.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false

        label.addSubview(self)

        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: label.topAnchor),
            self.bottomAnchor.constraint(equalTo: label.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: label.trailingAnchor)
        ])

        self.prepare()
    }

    private func prepare() {
        self.numberOfLinesObserver = self.label.observe(\.numberOfLines) { [weak self] (_, _) in
            self?.textDidChange()
        }

        self.textValueObserver = self.label.observe(\.text) { [weak self] (_, _) in
            self?.textDidChange()
        }
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.preferredContentSizeCategory != self.traitCollection.preferredContentSizeCategory {
            self.textDidChange()
        }
    }

    private func textDidChange() {
        guard self.isMultilineText else {
            self.asOneLineText()
            return
        }

        self.asMultilineText()
    }

    private func asOneLineText() {
        self.label?.minimumScaleFactor = self.overrideMinimumScaleFactor ?? 0.0
        self.label?.adjustsFontSizeToFitWidth = self.overrideAdjustsFontSizeToFitWidth ?? true
    }

    private func asMultilineText() {
        let needToUpdate: Bool = {
            if #available(iOS 11.0, tvOS 11.0, *) {
                return self.traitCollection
                    .preferredContentSizeCategory >= (
                        self.limitContentSize ??
                        self.traitCollection.preferredContentSizeCategory
                )
            }

            let comparationResult = [UIContentSizeCategory]([
                .unspecified, .extraSmall, .small,
                .medium, .large, .extraLarge,
                .extraExtraLarge, .extraExtraExtraLarge, .accessibilityMedium,
                .accessibilityLarge, .accessibilityExtraLarge,
                .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge
            ]).reduce((false, false)) {
                let isGratherOrEqualToLimitsSize = $0.1 ||
                    $1 == (self.limitContentSize ??
                        self.traitCollection.preferredContentSizeCategory)

                return ($0.0 || (
                    isGratherOrEqualToLimitsSize &&
                        $1 == self.traitCollection.preferredContentSizeCategory
                    ), isGratherOrEqualToLimitsSize)
                }

            return comparationResult.1 && comparationResult.0
        }()

        if needToUpdate {
            self.label?.hyphenate(factor: Float(self.hyphenFactor))
        } else {
            self.label?.removeHyphen()
        }
    }

    public func setLimitContentSize(category contentSizeCategory: UIContentSizeCategory) {
        self.limitContentSize = contentSizeCategory
        self.textDidChange()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate static func orEmpty(in label: UILabel) -> UMDynamicTextSize? {
        return label.subviews.first(where: { $0 is UMDynamicTextSize }) as? UMDynamicTextSize
    }

    fileprivate static func orCreate(in label: UILabel) -> UMDynamicTextSize {
        return self.orEmpty(in: label) ?? UMDynamicTextSize(label)
    }

    override public func removeFromSuperview() {
        super.removeFromSuperview()
        self.label?.adjustsFontForContentSizeCategory = false
    }
}

public class UMLabel: UILabel {
    deinit {
        if #available(iOS 11, *) {
            return
        }

        guard let textObserver = self.dynamicText?.textValueObserver else {
            return
        }

        self.removeObserver(textObserver, forKeyPath: "text")

        guard let numberOfLinesObserver = self.dynamicText?.numberOfLinesObserver else {
            return
        }

        self.removeObserver(numberOfLinesObserver, forKeyPath: "numberOfLines")
    }
}

public extension UILabel {
    @IBInspectable var isDynamicTextSize: Bool {
        get { return UMDynamicTextSize.orEmpty(in: self) != nil }
        set {
            guard newValue else {
                UMDynamicTextSize.orEmpty(in: self)?.removeFromSuperview()
                return
            }

            _ = UMDynamicTextSize.orCreate(in: self)
        }
    }

    @IBInspectable var hyphenFactor: CGFloat {
        get { return self.dynamicText?.hyphenFactor ?? 0 }
        set {
            UMDynamicTextSize.orCreate(in: self).hyphenFactor = newValue
        }
    }

    var dynamicText: UMDynamicTextSize? {
        return .orEmpty(in: self)
    }
}

public class UMLineLabel: UMLabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepare()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.prepare()
    }

    init() {
        super.init(frame: .zero)
        self.prepare()
    }

    func prepare() {
        self.isDynamicTextSize = true
        self.numberOfLines = 1
        self.minimumScaleFactor = 0
        self.adjustsFontSizeToFitWidth = true
    }
}

public class UMMultilineLabel: UMLabel {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepare()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.prepare()
    }

    public init() {
        super.init(frame: .zero)
        self.prepare()
    }

    public func prepare() {
        self.isDynamicTextSize = true
        self.numberOfLines = 0
        self.hyphenFactor = 0.3
    }
}

private extension UILabel {
    var paragraphStyle: NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = self.textAlignment
        paragraphStyle.lineBreakMode = self.lineBreakMode

        return paragraphStyle
    }

    func hyphenate(factor: Float = 1.0) {
        let paragraphStyle = self.paragraphStyle
        let attstr: NSMutableAttributedString = {
            if let attributedText = self.attributedText {
                return NSMutableAttributedString(attributedString: attributedText)
            }

            return NSMutableAttributedString(string: self.text ?? "")
        }()

        paragraphStyle.hyphenationFactor = factor
        attstr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(0..<attstr.length))
        self.attributedText = attstr
    }

    func removeHyphen() {
        let paragraphStyle = NSMutableParagraphStyle()
        let attstr = NSMutableAttributedString(attributedString: self.attributedText!)
        paragraphStyle.hyphenationFactor = 0
        attstr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(0..<attstr.length))
        self.attributedText = attstr
    }
}
#endif
