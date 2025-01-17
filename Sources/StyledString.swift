//
//  StyledString.swift
//  StylesString
//
//  Created by Sander de Vos on 30/11/15.
//  Copyright © 2015 Sander de Vos. All rights reserved.
//

import Foundation
import UIKit

public struct StyledString {
  fileprivate let node: StyleNode

  public var style = Style()

  public init() {
    self.node = .unary("")
  }

  public init(_ string: String) {
    self.node = .unary(string)
  }

  internal init(node: StyleNode) {
    self.node = node
  }

  internal init(string: String, style: Style) {
    self.node = .unary(string)
    self.style = style
  }

  internal init(lhs: StyledString, rhs: StyledString, style: Style) {
    self.node = .binary(lhs, rhs)
    self.style = style
  }
}

// MARK: ExpressibleByStringLiteral

extension StyledString: ExpressibleByStringLiteral {
  public typealias StringLiteralType = String

  public init(stringLiteral value: String) {
    self.init(value)
  }

  public init(extendedGraphemeClusterLiteral value: String) {
    self.init(value)
  }

  public init(unicodeScalarLiteral value: String) {
    self.init(value)
  }
}

// MARK: Support Types

indirect enum StyleNode {
  case unary(String)
  case binary(StyledString, StyledString)
}

public enum TextEffect  {
  case letterPress
}

public enum Link {
  case url(URL)
  case text(String)
}

// MARK: NSAttributedString support

public extension StyledString {

  public init(attributedString: NSAttributedString) {

    let range = NSRange(location: 0, length: attributedString.length)
    let nsString = attributedString.string as NSString

    var segments: [StyledString] = []

    attributedString.enumerateAttributes(in: range, options: []) { (attributes, range, _) in
      let substring = nsString.substring(with: range)
      let styledString = StyledString(string: substring, style: Style(attributes: attributes))
      segments.append(styledString)
    }

    self.node = segments.joined(separator: "").node
  }

  public var nsAttributedString: NSAttributedString {
    return attributedString(parentStyle: style)
  }

  @available(*, unavailable, renamed: "nsAttributedString")
  public var attributedString: NSAttributedString {
    fatalError()
  }

  private func attributedString(parentStyle: Style) -> NSAttributedString {
    switch node {
    case let .unary(string):
      return Foundation.NSAttributedString(string: string, style: parentStyle)

    case let .binary(lhs, rhs):
      let las = lhs.attributedString(parentStyle: parentStyle.merge(lhs.style))
      let ras = rhs.attributedString(parentStyle: parentStyle.merge(rhs.style))

      return las + ras
    }
  }
}

// MARK: Mutation

extension StyledString {
  public func mapStyle(transform: ((StyledString.Style) -> StyledString.Style)) -> StyledString {
    switch self.node {
    case let .unary(string):
      return StyledString(string: string, style: transform(self.style))

    case let .binary(lhs, rhs):
      return StyledString(
        lhs: lhs.mapStyle(transform: transform),
        rhs: rhs.mapStyle(transform: transform),
        style: transform(style))
    }
  }
}

// MARK: Equtabale

extension StyledString: Equatable {
  public static func == (lhs: StyledString, rhs: StyledString) -> Bool {
    return lhs.nsAttributedString.isEqual(to: rhs.nsAttributedString)
  }
}

// MARK: Style vars

public extension StyledString {

  public var font: UIFont? {
    get { return style.font }
    set { style.font = newValue }
  }

  public var foregroundColor: UIColor? {
    get { return style.foregroundColor }
    set { style.foregroundColor = newValue }
  }

  public var backgroundColor: UIColor? {
    get { return style.backgroundColor }
    set { style.backgroundColor = newValue }
  }

  public var ligatures: Bool? {
    get { return style.ligature }
    set { style.ligature = newValue }
  }

  public var kerning: Float? {
    get { return style.kern }
    set { style.kern = newValue }
  }

  public var underlineStyle: NSUnderlineStyle? {
    get { return style.underlineStyle }
    set { style.underlineStyle = newValue }
  }

  public var underlineColor: UIColor? {
    get { return style.underlineColor }
    set { style.underlineColor = newValue }
  }

  public var strikethroughStyle: NSUnderlineStyle? {
    get { return style.strikethroughStyle }
    set { style.strikethroughStyle = newValue }
  }

  public var strikethroughColor: UIColor? {
    get { return style.strikethroughColor }
    set { style.strikethroughColor = newValue }
  }

  public var strokeWidth: Float?  {
    get { return style.strokeWidth }
    set { style.strokeWidth = newValue }
  }

  public var strokeColor: UIColor?  {
    get { return style.strokeColor }
    set { style.strokeColor = newValue }
  }

  public var shadowOffset: CGSize?  {
    get { return style.shadowOffset }
    set { style.shadowOffset = newValue }
  }

  public var shadowBlurRadius: CGFloat?  {
    get { return style.shadowBlurRadius }
    set { style.shadowBlurRadius = newValue }
  }

  public var shadowColor: UIColor?  {
    get { return style.shadowColor }
    set { style.shadowColor = newValue }
  }

  public var textEffect: TextEffect? {
    get { return style.textEffect }
    set { style.textEffect = newValue }
  }

  public var attachment: NSTextAttachment? {
    get { return style.attachment }
    set { style.attachment = newValue }
  }

  public var link: Link? {
    get { return style.link }
    set { style.link = newValue }
  }

  public var baselineOffset: Float? {
    get { return style.baselineOffset }
    set { style.baselineOffset = newValue }
  }

  public var obliqueness: Float? {
    get { return style.obliqueness }
    set { style.obliqueness = newValue }
  }

  public var expansion: Float? {
    get { return style.expansion }
    set { style.expansion = newValue }
  }

  public var writingDirection: [Int]? {
    get { return style.writingDirection }
    set { style.writingDirection = newValue }
  }

  public var verticalGlyphForm: Bool? {
    get { return style.verticalGlyphForm }
    set { style.verticalGlyphForm = newValue }
  }

  public var alignment: NSTextAlignment? {
    get { return style.alignment }
    set { style.alignment = newValue }
  }

  public var firstLineHeadIndent: CGFloat? {
    get { return style.firstLineHeadIndent }
    set { style.firstLineHeadIndent = newValue }
  }

  public var headIndent: CGFloat? {
    get { return style.headIndent }
    set { style.headIndent = newValue }
  }

  public var tailIndent: CGFloat? {
    get { return style.tailIndent }
    set { style.tailIndent = newValue }
  }

  public var lineHeightMultiple: CGFloat? {
    get { return style.lineHeightMultiple }
    set { style.lineHeightMultiple = newValue }
  }

  public var maximumLineHeight: CGFloat? {
    get { return style.maximumLineHeight }
    set { style.maximumLineHeight = newValue }
  }

  public var minimumLineHeight: CGFloat? {
    get { return style.minimumLineHeight }
    set { style.minimumLineHeight = newValue }
  }

  public var lineSpacing: CGFloat? {
    get { return style.lineSpacing }
    set { style.lineSpacing = newValue }
  }

  public var paragraphSpacing: CGFloat? {
    get { return style.paragraphSpacing }
    set { style.paragraphSpacing = newValue }
  }

  public var paragraphSpacingBefore: CGFloat? {
    get { return style.paragraphSpacingBefore }
    set { style.paragraphSpacingBefore = newValue }
  }

  public var defaultTabInterval: CGFloat? {
    get { return style.defaultTabInterval }
    set { style.defaultTabInterval = newValue }
  }

  public var tabStops: [NSTextTab]? {
    get { return style.tabStops }
    set { style.tabStops = newValue }
  }

  public var lineBreakMode: NSLineBreakMode? {
    get { return style.lineBreakMode }
    set { style.lineBreakMode = newValue }
  }

  public var hyphenationFactor: Float? {
    get { return style.hyphenationFactor }
    set { style.hyphenationFactor = newValue }
  }

  public var baseWritingDirection: NSWritingDirection? {
    get { return style.baseWritingDirection }
    set { style.baseWritingDirection = newValue }
  }

}

// MARK: Style methods

public extension StyledString {
  public func with(font: UIFont?) -> StyledString {
    var new = self
    new.style.font = font
    return new
  }

  public func with(foregroundColor: UIColor?) -> StyledString {
    var new = self
    new.style.foregroundColor = foregroundColor
    return new
  }

  public func with(backgroundColor: UIColor?) -> StyledString {
    var new = self
    new.style.backgroundColor = backgroundColor
    return new
  }

  public func with(ligatures: Bool?) -> StyledString {
    var new = self
    new.style.ligature = ligatures
    return new
  }

  public func withLigatures() -> StyledString {
    return self.with(ligatures: true)
  }

  public func with(kerning kern: Float?) -> StyledString {
    var new = self
    new.style.kern = kern
    return new
  }

  public func with(underlineStyle style: NSUnderlineStyle?, color: UIColor? = nil) -> StyledString {
    var new = self
    new.style.underlineStyle = style
    new.style.underlineColor = color
    return new
  }

  public func withUnderline() -> StyledString {
    return self.with(underlineStyle: NSUnderlineStyle.single)
  }

  public func with(strikethroughStyle style: NSUnderlineStyle?, color: UIColor? = nil) -> StyledString {
    var new = self
    new.style.strikethroughStyle = style
    new.style.strikethroughColor = color
    return new
  }

  public func withStrikethrough() -> StyledString {
    return self.with(strikethroughStyle: NSUnderlineStyle.single)
  }

  public func with(strokeWidth width: Float?, color: UIColor? = nil) -> StyledString {
    var new = self
    new.style.strokeWidth = width
    new.style.strokeColor = color
    return new
  }

  public func withStroke() -> StyledString {
    return self.with(strokeWidth: 1)
  }

  public func with(shadowOffset offset: CGSize?, blurRadius: CGFloat? = 0, color: UIColor? = nil) -> StyledString {
    var new = self
    new.style.shadowOffset = offset
    new.style.shadowBlurRadius = blurRadius
    new.style.shadowColor = color
    return new
  }

  public func withShadow() -> StyledString {
    return self.with(shadowOffset: CGSize(width: 1, height: 1))
  }

  public func with(textEffect effect: TextEffect?) -> StyledString {
    var new = self
    new.style.textEffect = effect
    return new
  }

  public func withTextEffect() -> StyledString {
    return self.with(textEffect: .letterPress)
  }

  public func with(attachment: NSTextAttachment?) -> StyledString {
    var new = self
    new.style.attachment = attachment
    return new
  }

  public func with(link: URL?) -> StyledString {
    var new = self
    if let link = link {
      new.style.link = .url(link)
    } else {
      new.style.link = nil
    }
    return new
  }

  public func with(link: String?) -> StyledString {
    var new = self
    if let link = link {
      new.style.link = .text(link)
    } else {
      new.style.link = nil
    }
    return new
  }

  public func with(baselineOffset offset: Float?) -> StyledString {
    var new = self
    new.style.baselineOffset = offset
    return new
  }

  public func with(obliqueness: Float?) -> StyledString {
    var new = self
    new.style.obliqueness = obliqueness
    return new
  }

  public func with(expansion: Float?) -> StyledString {
    var new = self
    new.style.expansion = expansion
    return new
  }

  public func with(writingDirection: [Int]?) -> StyledString {
    var new = self
    new.style.writingDirection = writingDirection
    return new
  }

  public func with(verticalGlyphForm: Bool?) -> StyledString {
    var new = self
    new.style.verticalGlyphForm = verticalGlyphForm
    return new
  }

  public func withVerticalGlyphForm() -> StyledString {
    return self.with(verticalGlyphForm: true)
  }

  public func with(alignment: NSTextAlignment?) -> StyledString {
    var new = self
    new.style.alignment = alignment
    return new
  }

  public func with(firstLineHeadIndent: CGFloat?) -> StyledString {
    var new = self
    new.style.firstLineHeadIndent = firstLineHeadIndent
    return new
  }

  public func with(headIndent: CGFloat?) -> StyledString {
    var new = self
    new.style.headIndent = headIndent
    return new
  }

  public func with(tailIndent: CGFloat?) -> StyledString {
    var new = self
    new.style.tailIndent = tailIndent
    return new
  }

  public func with(lineHeightMultiple: CGFloat?) -> StyledString {
    var new = self
    new.style.lineHeightMultiple = lineHeightMultiple
    return new
  }

  public func with(maximumLineHeight: CGFloat?) -> StyledString {
    var new = self
    new.style.maximumLineHeight = maximumLineHeight
    return new
  }

  public func with(minimumLineHeight: CGFloat?) -> StyledString {
    var new = self
    new.style.minimumLineHeight = minimumLineHeight
    return new
  }

  public func with(lineSpacing: CGFloat?) -> StyledString {
    var new = self
    new.style.lineSpacing = lineSpacing
    return new
  }

  public func with(paragraphSpacing: CGFloat?) -> StyledString {
    var new = self
    new.style.paragraphSpacing = paragraphSpacing
    return new
  }

  public func with(paragraphSpacingBefore: CGFloat?) -> StyledString {
    var new = self
    new.style.paragraphSpacingBefore = paragraphSpacingBefore
    return new
  }

  public func with(defaultTabInterval: CGFloat?) -> StyledString {
    var new = self
    new.style.defaultTabInterval = defaultTabInterval
    return new
  }

  public func with(tabStops: [NSTextTab]?) -> StyledString {
    var new = self
    new.style.tabStops = tabStops
    return new
  }

  public func with(lineBreakMode: NSLineBreakMode?) -> StyledString {
    var new = self
    new.style.lineBreakMode = lineBreakMode
    return new
  }

  public func with(hyphenationFactor: Float?) -> StyledString {
    var new = self
    new.style.hyphenationFactor = hyphenationFactor
    return new
  }

  public func with(baseWritingDirection: NSWritingDirection?) -> StyledString {
    var new = self
    new.style.baseWritingDirection = baseWritingDirection
    return new
  }

}

// MARK: StyledString Operators

public func + (lhs: StyledString, rhs: StyledString) -> StyledString {
  return StyledString(node: .binary(lhs, rhs))
}

// MARK: SequenceType Additions

extension Sequence where Iterator.Element == StyledString {

  /// Interpose the `separator` between elements of `self`, then concatenate
  /// the result.  For example:
  ///
  ///     ["foo", "bar", "baz"].joinWithSeparator("-|-") // "foo-|-bar-|-baz"
  public func joined(separator: String) -> StyledString {
    return self.joined(separator: StyledString(separator))
  }

  /// Interpose the `separator` between elements of `self`, then concatenate
  /// the result.  For example:
  ///
  ///     ["foo", "bar", "baz"].joinWithSeparator("-|-") // "foo-|-bar-|-baz"
  public func joined(separator: StyledString) -> StyledString {
    var result = StyledString("")

    var first = true
    for item in self {
      if !first {
        result = result + separator
      }

      first = false

      result = result + item
    }

    return result
  }
}
