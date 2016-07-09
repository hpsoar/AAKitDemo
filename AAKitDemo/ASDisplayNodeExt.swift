//
//  ASDisplayNodeExt.swift
//  AAKitDemo
//
//  Created by HuangPeng on 7/10/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

import UIKit
import ObjectiveC

extension ASDisplayNode {
    
    func spacingBefore(spacingBefore: CGFloat) -> Self {
        self.spacingBefore = spacingBefore
        return self
    }
    
    func spacingAfter(spacingAfter: CGFloat) -> Self {
        self.spacingAfter = spacingAfter
        return self
    }
    
    func flexGrow(flexGrow: Bool) -> Self {
        self.flexGrow = flexGrow
        return self
    }
    
    func flexShrink(flexShrink: Bool) -> Self {
        self.flexShrink = flexShrink
        return self
    }
    
    func alignSelf(alignSelf: ASStackLayoutAlignSelf) -> Self {
        self.alignSelf = alignSelf
        return self
    }
    
    func flexBasis(flexBasis: ASRelativeDimension) -> Self {
        self.flexBasis = flexBasis
        return self
    }
    
    func ascender(ascender: CGFloat) -> Self {
        self.ascender = ascender
        return self
    }
    
    func descender(descender: CGFloat) -> Self {
        self.descender = descender
        return self
    }
    
    func addSubnodes(nodes: [ASDisplayNode]) -> Self {
        for n in nodes {
            addSubnode(n)
        }
        return self
    }
    
    func preferredFrameSize(preferredFrameSize: CGSize) -> Self {
        self.preferredFrameSize = preferredFrameSize
        return self
    }
    
    func displaysAsynchronously(displaysAsynchronously: Bool) -> Self {
        self.displaysAsynchronously = displaysAsynchronously
        for n in subnodes {
            n.displaysAsynchronously = displaysAsynchronously
        }
        return self
    }
}

private var ASTextNodeStyleKey: UInt8 = 0

extension ASTextNode {
    var style: AALabelAttributes! {
        get {
            var style = objc_getAssociatedObject(self, &ASTextNodeStyleKey) as? AALabelAttributes
            if style == nil {
                style = AALabelAttributes()
                objc_setAssociatedObject(self, &ASTextNodeStyleKey, style, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
            return style
        }
        set {
            objc_setAssociatedObject(self, &ASTextNodeStyleKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func maximumNumberOfLines(maximumNumberOfLines: UInt) -> Self {
        self.maximumNumberOfLines = maximumNumberOfLines
        return self
    }
    
    func truncationMode(truncationMode: NSLineBreakMode) -> Self {
        self.truncationMode = truncationMode
        return self
    }
    
    func style(font font: UIFont, hexColor: NSInteger, text: String?) -> Self {
        style.font(font).hexColor(hexColor).text(text)
        return self
    }
    
    func style(fontSize fontSize: CGFloat, hexColor: NSInteger, text: String?) -> Self {
        return style(font:UIFont.systemFontOfSize(fontSize), hexColor: hexColor, text: text)
    }
    
    func style(style: AALabelAttributes) -> Self {
        self.style = style
        self.applyStyle()
        return self
    }
    
    func applyStyle() -> Self {
        self.maximumNumberOfLines = UInt(style.maximumNumberOfLines)
        self.truncationMode = style.lineBreakMode
        self.attributedText = style.attributedText ?? self.attributedText
        return self
    }
}

extension ASNetworkImageNode {
    func defaultImage(defaultImage: UIImage?) -> Self {
        self.defaultImage = defaultImage
        return self
    }
    
    func defaultImageNamed(name: String) -> Self {
        return defaultImage(UIImage(named: name))
    }
    
    func URL(url: String) -> Self {
        self.URL = NSURL(string: url)
        return self
    }
    
    func fileURL(url: String) -> Self {
        self.URL = NSURL(fileURLWithPath: url)
        return self
    }
}

extension ASLayoutSpec {
    func spacingBefore(spacingBefore: CGFloat) -> Self {
        self.spacingBefore = spacingBefore
        return self
    }
    
    func spacingAfter(spacingAfter: CGFloat) -> Self {
        self.spacingAfter = spacingAfter
        return self
    }
    
    func flexGrow(flexGrow: Bool) -> Self {
        self.flexGrow = flexGrow
        return self
    }
    
    func flexShrink(flexShrink: Bool) -> Self {
        self.flexShrink = flexShrink
        return self
    }
    
    func alignSelf(alignSelf: ASStackLayoutAlignSelf) -> Self {
        self.alignSelf = alignSelf
        return self
    }
    
    func flexBasis(flexBasis: ASRelativeDimension) -> Self {
        self.flexBasis = flexBasis
        return self
    }
    
    func ascender(ascender: CGFloat) -> Self {
        self.ascender = ascender
        return self
    }
    
    func descender(descender: CGFloat) -> Self {
        self.descender = descender
        return self
    }    
}

extension ASLayoutable {
    func asInsets(insets: UIEdgeInsets) -> ASInsetLayoutSpec {
        return ASInsetLayoutSpec(insets: insets, child: self)
    }
}

extension ASInsetLayoutSpec {
    convenience init(child:ASLayoutable) {
        self.init()
        self.setChild(child)
    }
    
    func insets(insets: UIEdgeInsets) -> Self {
        self.insets = insets
        return self
    }
}

extension ASStackLayoutSpec {
    convenience init(children: [ASLayoutable]) {
        self.init()
        self.setChildren(children)
    }
    
    func horizontalAlignment(horizontalAlignment: ASHorizontalAlignment) -> Self {
        self.horizontalAlignment = horizontalAlignment
        return self
    }
    
    func verticalAlignment(verticalAlignment: ASVerticalAlignment) -> Self {
        self.verticalAlignment = verticalAlignment
        return self
    }
    
    func justifyContent(justifyContent: ASStackLayoutJustifyContent) -> Self {
        self.justifyContent = justifyContent
        return self
    }
    
    func child(child: ASLayoutable) -> Self {
        setChild(child)
        return self
    }
    
    func children(children: [ASLayoutable]) -> Self {
        setChildren(children)
        return self
    }
    
    func spacing(spacing: CGFloat) -> Self {
        self.spacing = spacing
        return self
    }
    
    func alignItems(alignItems: ASStackLayoutAlignItems) -> Self {
        self.alignItems = alignItems
        return self
    }
}

class ASVStackLayoutSpec: ASStackLayoutSpec {
    convenience init(children: [ASLayoutable]) {
        self.init(spacing:0, alignItems: .Start, children: children)
    }
    
    init(spacing: CGFloat, alignItems: ASStackLayoutAlignItems, children:[ASLayoutable]) {
        super.init()
        //super.init(direction: .Vertical, spacing: spacing, justifyContent: .Start, alignItems: alignItems, children: children)
        self.justifyContent = .Start
        self.spacing = spacing
        self.direction = .Vertical
        self.alignItems = alignItems
        self.setChildren(children)
    }
}

class ASHStackLayoutSpec: ASStackLayoutSpec {
    convenience init(children: [ASLayoutable]) {
        self.init(spacing:0, alignItems: .Start, children: children)
    }
    
    init(spacing: CGFloat, alignItems: ASStackLayoutAlignItems, children:[ASLayoutable]) {
        super.init()
        //super.init(direction: .Vertical, spacing: spacing, justifyContent: .Start, alignItems: alignItems, children: children)
        self.spacing = spacing
        self.direction = .Horizontal
        self.alignItems = alignItems
        self.setChildren(children)
    }
}

extension Array where Element:ASLayoutable {
    func asStack(direction: ASStackLayoutDirection, spacing: CGFloat) -> ASStackLayoutSpec {
        return ASStackLayoutSpec(direction: direction, spacing: spacing, justifyContent: .Start, alignItems: .Start, children: self)
    }
    
    func asStack(direction: ASStackLayoutDirection) -> ASStackLayoutSpec {
        return asStack(direction, spacing: 0)
    }
    
    func asVStack() -> ASStackLayoutSpec {
        return asStack(.Vertical, spacing: 0)
    }
    
    func asHStack() -> ASStackLayoutSpec {
        return asStack(.Horizontal, spacing: 0)
    }
}
