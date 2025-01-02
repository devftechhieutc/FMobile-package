//
//  AttributedStringBuilder.swift
//  FMobile
//
//  Created by Tran Hieu on 21/11/24.
//

import UIKit

public class AttributedStringBuilder {

    private var listAttString: [(string: String?, attrs: [NSAttributedString.Key : Any])] = []
    private var lastStartAttIndex: Int = 0
    
    public init() {}
    
    @discardableResult
    public func append(_ text: String?) -> AttributedStringBuilder {
        lastStartAttIndex = listAttString.count
        listAttString.append((text, [:]))
        return self
    }
    
    @discardableResult
    public func with(_ color: UIColor) -> AttributedStringBuilder {
        listAttString[lastStartAttIndex].attrs[
            NSAttributedString.Key.foregroundColor
        ] = color
        return self
    }
    
    @discardableResult
    public func with(_ font: UIFont) -> AttributedStringBuilder {
        listAttString[lastStartAttIndex].attrs[
            NSAttributedString.Key.font
        ] = font
        return self
    }
    
    @discardableResult
    public func with(_ underLineStyle: NSUnderlineStyle) -> AttributedStringBuilder {
        listAttString[lastStartAttIndex].attrs[
            NSAttributedString.Key.underlineStyle
        ] = underLineStyle.rawValue
        return self
    }
    
    @discardableResult
    public func with(_ paragraphStyle: NSParagraphStyle) -> AttributedStringBuilder {
        listAttString[lastStartAttIndex].attrs[
            NSAttributedString.Key.paragraphStyle
        ] = paragraphStyle
        return self
    }
    
    @discardableResult
    public func with(_ link: URL) -> AttributedStringBuilder {
        listAttString[lastStartAttIndex].attrs[
            NSAttributedString.Key.link
        ] = link
        return self
    }
    
    @discardableResult
    public func with(strikethrough color: UIColor, height: CGFloat = 1.0) -> AttributedStringBuilder {
        listAttString[lastStartAttIndex].attrs[
            NSAttributedString.Key.strikethroughColor
        ] = color
        listAttString[lastStartAttIndex].attrs[
            NSAttributedString.Key.strikethroughStyle
        ] = height
        return self
    }
    
    @discardableResult
    public func with(bgColor color: UIColor) -> AttributedStringBuilder {
        listAttString[lastStartAttIndex].attrs[
            NSAttributedString.Key.backgroundColor
        ] = color
        return self
    }
    
    public func with(_ baselineOffset: CGFloat) -> AttributedStringBuilder {
        listAttString[lastStartAttIndex].attrs[
            NSAttributedString.Key.baselineOffset
        ] = baselineOffset
        return self
    }
    
    public func attributedString() -> NSMutableAttributedString {
        let result = NSMutableAttributedString()
        for attString in listAttString {
            if let string = attString.string, string.count > 0 {
                result.append(NSAttributedString(string: string, attributes: attString.attrs))
            }
        }
        return result
    }
}
