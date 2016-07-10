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
    
    func asd_layout(sizeRange sizeRange: ASSizeRange) -> ASLayout {
        let layout = measureWithSizeRange(sizeRange)        
        self.frame = CGRectMake(0, 0, self.calculatedSize.width, self.calculatedSize.height)
        return layout
    }
    
    func asd_layout(width width: CGFloat) -> ASLayout {
        return asd_layout(sizeRange: ASSizeRangeMake(CGSizeMake(width, 0), CGSizeMake(width, CGFloat.max)))
    }
    
    func asd_layout(width width: CGFloat, height: CGFloat) -> ASLayout {
        return asd_layout(sizeRange: ASSizeRangeMake(CGSizeMake(width, height), CGSizeMake(width, height)))
    }
    
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
    
//    func sizeRange(sizeRange: ASSizeRange) -> Self {
//        self.sizeRange = sizeRange
//        return self
//    }
    
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
    
    func addToSupernode(superNode: ASDisplayNode) -> Self {
        superNode.addSubnode(self)
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

extension ASDisplayNode {
    
    func contents(contents: AnyObject?) -> Self {
        self.contents = contents
        return self
    }
    
    func clipsToBounds(clipsToBounds: Bool) -> Self {
        self.clipsToBounds = clipsToBounds
        return self
    }
    
    func opaque(opaque: Bool) -> Self {
        self.opaque = opaque
        return self
    }
    
    func allowsEdgeAntialiasing(allowsEdgeAntialiasing: Bool) -> Self {
        self.allowsEdgeAntialiasing = allowsEdgeAntialiasing
        return self
    }
    
    func edgeAntialiasingMask(edgeAntialiasingMask: UInt32) -> Self {
        self.edgeAntialiasingMask = edgeAntialiasingMask
        return self
    }
    
    func hidden(hidden: Bool) -> Self {
        self.hidden = hidden
        return self
    }
    
    func autoresizesSubviews(autoresizesSubviews: Bool) -> Self {
        self.autoresizesSubviews = autoresizesSubviews
        return self
    }
    
    func autoresizingMask(autoresizingMask: UIViewAutoresizing) -> Self {
        self.autoresizingMask = autoresizingMask
        return self
    }
    
    func alpha(alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }
    
    func frame(frame: CGRect) -> Self {
        self.frame = frame
        return self
    }
    
    func contentsScale(contentsScale: CGFloat) -> Self {
        self.contentsScale = contentsScale
        return self
    }
    
    func backgroundColor(color: UIColor?) -> Self {
        backgroundColor = color
        return self
    }
    
    func backgroundHexColor(hexColor: NSInteger) -> Self {
        return backgroundColor(UIColor.hexColor(hexColor))
    }
    
    func contentMode(contentMode: UIViewContentMode) -> Self {
        self.contentMode = contentMode
        return self
    }
    
    func userInteractionEnabled(userInteractionEnabled: Bool) -> Self {
        self.userInteractionEnabled = userInteractionEnabled
        return self
    }
    
    func exclusiveTouch(exclusiveTouch: Bool) -> Self {
        self.exclusiveTouch = exclusiveTouch
        return self
    }
    
    func cornerRadius(cornerRadius: CGFloat) -> Self {
        self.cornerRadius = cornerRadius
        clipsToBounds = true
        return self
    }
    
    func borderColor(color: UIColor) -> Self {
        self.borderColor = color.CGColor
        return self
    }
    
    func borderHexColor(hexColor: NSInteger) -> Self {
        return borderColor(UIColor.hexColor(hexColor))
    }
    
    func borderWidth(width: CGFloat) -> Self {
        self.borderWidth = width
        return self
    }
    
    func border(width width: CGFloat, hexColor: NSInteger, cornerRadius: CGFloat) -> Self {
        return borderWidth(width).borderHexColor(hexColor).cornerRadius(cornerRadius)
    }
    
    func shadow(offset: CGSize, radius:CGFloat, color:UIColor, opacity:CGFloat) -> Self {
        self.shadowOffset = offset
        self.shadowRadius = radius
        self.shadowColor = color.CGColor
        self.shadowOpacity = opacity
        return self
    }
    
    func shadow(offset: CGSize, radius:CGFloat, hexColor:NSInteger, opacity:CGFloat) -> Self {
        return shadow(offset, radius: radius, color: UIColor.hexColor(hexColor), opacity: opacity)
    }
    
    func shadowOffset(shadowOffset: CGSize) -> Self {
        self.shadowOffset = shadowOffset
        return self
    }
    
    func shadowRadius(shadowRadius: CGFloat) -> Self {
        self.shadowRadius = shadowRadius
        return self
    }
    
    func shadowColor(shadowColor: UIColor) -> Self {
        self.shadowColor = shadowColor.CGColor
        return self
    }
    
    func shadowHexColor(hexColor: NSInteger) -> Self {
        self.shadowColor = UIColor.hexColor(hexColor).CGColor
        return self
    }
    
    func shadowOpacity(shadowOpacity: CGFloat) -> Self {
        self.shadowOpacity = shadowOpacity
        return self
    }
    
    func needsDisplayOnBoundsChange(needsDisplayOnBoundsChange: Bool) -> Self {
        self.needsDisplayOnBoundsChange = needsDisplayOnBoundsChange
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
    
    func style(style: AALabelAttributes) -> Self {
        self.style = style
        self.applyStyle()
        return self
    }
    
    private func applyStyle() -> Self {        
        self.attributedText = style.attributedText ?? self.attributedText
        return self
    }
}

func asd_textStyle() -> AALabelAttributes {
    return AALabelAttributes()
}

func asd_textStyle(fontSize fontSize: CGFloat, hexColor: NSInteger, text: String?) -> AALabelAttributes {
    return AALabelAttributes(fontSize: fontSize, hexColor: hexColor, text: text)
}

func asd_textStyle(font font: UIFont, hexColor: NSInteger, text: String?) -> AALabelAttributes {
    return AALabelAttributes(font: font, hexColor: hexColor, text: text)
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
    
    func asInsets(top top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> ASInsetLayoutSpec {
        return asInsets(UIEdgeInsetsMake(top, left, bottom, right))
    }
}

extension ASInsetLayoutSpec {
    convenience init(child:ASLayoutable) {
        self.init()
        setChild(child)
    }
    
    func insets(insets: UIEdgeInsets) -> Self {
        self.insets = insets
        return self
    }
    
    func child(child: ASLayoutable) -> Self {
        setChild(child)
        return self
    }
}

func asd_insets(top top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> ASInsetLayoutSpec {
    return ASInsetLayoutSpec().insets(UIEdgeInsetsMake(top, left, bottom, right))
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

func asd_hStack(children: [ASLayoutable]) -> ASStackLayoutSpec {
    return ASHStackLayoutSpec(children: children)
}

func asd_vStack(children: [ASLayoutable]) -> ASStackLayoutSpec {
    return ASVStackLayoutSpec(children: children)
}

func asd_hStack() -> ASStackLayoutSpec {
    return asd_hStack([])
}

func asd_vStack() -> ASStackLayoutSpec {
    return asd_vStack([])
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

extension ASButtonNode {
    
    func contentSpacing(contentSpacing: CGFloat) -> Self {
        self.contentSpacing = contentSpacing
        return self
    }
    
    func laysOutHorizontally(laysOutHorizontally: Bool) -> Self {
        self.laysOutHorizontally = laysOutHorizontally
        return self
    }
    
    func contentHorizontalAlignment(contentHorizontalAlignment: ASHorizontalAlignment) -> Self {
        self.contentHorizontalAlignment = contentHorizontalAlignment
        return self
    }
    
    func contentVerticalAlignment(contentVerticalAlignment: ASVerticalAlignment) -> Self {
        self.contentVerticalAlignment = contentVerticalAlignment
        return self
    }
    
    func contentEdgeInsets(contentEdgeInsets: UIEdgeInsets) -> Self {
        self.contentEdgeInsets = contentEdgeInsets
        return self
    }
    
    func attributedTitle(title: NSAttributedString?, forState state: ASControlState) -> Self {
        setAttributedTitle(title, forState: state)
        return self
    }
    
    func title(title: String, font:UIFont, color: UIColor, forState state: ASControlState) -> Self {
        setTitle(title, withFont: font, withColor: color, forState: state)
        return self
    }
    
    func title(title: String, fontSize:CGFloat, hexColor: NSInteger, forState state: ASControlState) -> Self {
        return self.title(title, font: UIFont.systemFontOfSize(fontSize), color: UIColor.hexColor(hexColor), forState: state)
    }
    
    func title(title: String, font:UIFont, hexColor: NSInteger, forState state: ASControlState) -> Self {
        return self.title(title, font: font, color: UIColor.hexColor(hexColor), forState: state)
    }
    
    func image(image: UIImage?, forState state: ASControlState) -> Self {
        setImage(image, forState: state)
        return self
    }
    
    func imageNamed(named: String?, forState state: ASControlState) -> Self {
        guard named != nil else {
            return image(nil, forState: state)
        }
        return image(UIImage(named: named!), forState: state)
    }
    
    func backgroundImage(image: UIImage?, forState state: ASControlState) -> Self {
        setBackgroundImage(image, forState: state)
        return self
    }
    
    func backgroundImageNamed(named: String?, forState state: ASControlState) -> Self {
        guard named != nil else {
            return backgroundImage(nil, forState: state)
        }
        return backgroundImage(UIImage(named: named!), forState: state)
    }
}
