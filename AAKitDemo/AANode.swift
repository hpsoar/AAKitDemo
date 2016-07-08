//
//  AANode.swift
//  ComponentDemo
//
//  Created by HuangPeng on 7/6/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

import UIKit

struct AASizeRange {
    init(min: CGSize, max: CGSize) {
        self.min = min
        self.max = max
    }
    
    init(max: CGSize) {
        self.max = max
    }
    
    init() {
    }
    
    var min = CGSize(width: 0, height: 0)
    var max = CGSize(width: CGFloat(Float.infinity), height:CGFloat(Float.infinity))
}

extension UIEdgeInsets {
    func aa_negate() -> UIEdgeInsets {
        return UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
    }
}

extension CGSize {
    func aa_insets(insets: UIEdgeInsets) -> CGSize {
        var size = self
        if size.width.isFinite {
            size.width += insets.left + insets.right
        }
        if size.height.isFinite {
            size.height += insets.top + insets.bottom
        }
        return size
    }
    
    func aa_nonnegative() -> CGSize {
        return CGSize(width: max(0.0, self.width), height: max(0.0, self.height))
    }
    
    func aa_min(size: CGSize) -> CGSize {
        return CGSize(width: min(self.width, size.width), height: min(self.height, size.height))
    }
    
    func aa_max(size: CGSize) -> CGSize {
        return CGSize(width: max(self.width, size.width), height: max(self.height, size.height))
    }
}

/// MARK: - Base Node

class AAUINode {
    var hidden = false
    
    var position = CGPointZero
    var size = CGSizeZero
    var frame = CGRectZero
    
    var sizeRange = AASizeRange()
    
    func sizeRange(sizeRange: AASizeRange) -> Self {
        self.sizeRange = sizeRange
        return self
    }
    
    // for static view node, simply set its size
    // eg. a button with static size
    func size(size: CGSize) -> Self {
        self.size = size
        return self
    }
    
    func setup(view: UIView) {
        view.frame = frame
        view.hidden = hidden
    }
    
    func layoutIfNeeded(constrainedSize: AASizeRange) -> Void {
        position = CGPointZero
        let sizeRange = AASizeRange(max: self.sizeRange.max.aa_min(constrainedSize.max))
        calculateSizeIfNeeded(sizeRange)
        calculateFrameIfNeeded()
    }
    
    func calculateSizeIfNeeded(constrainedSize: AASizeRange) -> Void {
        
    }
    
    func calculateFrameIfNeeded() -> Void {
        frame = CGRectMake(position.x, position.y, size.width, size.height)
    }
}

/// MARK: - stack node types

enum AAStackNodeAlignment {
    case Start
    case Center
    case End
}

enum AAStackNodeDirection {
    case Horizontal
    case Vertical
}

enum AAStackNodeChildAlignment {
    case Auto
    case Start
    case Center
    case End
    case Stretch
}

// MARK: - CGSize extension for stack

extension CGSize {
    func stackDimension(direction: AAStackNodeDirection) -> CGFloat {
        return direction == .Horizontal ? self.width : self.height
    }
    
    func crossDimension(direction: AAStackNodeDirection) -> CGFloat {
        return direction == .Horizontal ? self.height : self.width
    }
    
    func shrinkStackDimension(direction: AAStackNodeDirection, value: CGFloat) -> CGSize {
        var stackDimension = self.stackDimension(direction)
        if stackDimension.isFinite && value.isFinite {
            stackDimension += value
        }
        return CGSize.sizeWithStackCrossDimension(direction, stack: stackDimension, cross: crossDimension(direction))
    }
    
    mutating func stackDimension(direction: AAStackNodeDirection, stack: CGFloat) {
        self = CGSize.sizeWithStackCrossDimension(direction, stack: stack, cross: crossDimension(direction))
    }
    
    mutating func crossDimension(direction: AAStackNodeDirection, cross: CGFloat) {
        self = CGSize.sizeWithStackCrossDimension(direction, stack: stackDimension(direction), cross: cross)
    }
    
    static func sizeWithStackCrossDimension(direction: AAStackNodeDirection, stack: CGFloat, cross: CGFloat) -> CGSize {
        if direction == .Horizontal {
            return CGSizeMake(stack, cross)
        }
        else {
            return CGSizeMake(cross, stack)
        }
    }
}

// MARK: - CGPoint exension for stack

extension CGPoint {
    func stackOrigin(direction: AAStackNodeDirection) -> CGFloat {
        return direction == .Horizontal ? self.x : self.y
    }
    
    func crossOrigin(direction: AAStackNodeDirection) -> CGFloat {
        return direction == .Horizontal ? self.y : self.x
    }
    
    static func pointWithStackCrossOrigin(direction: AAStackNodeDirection, stack: CGFloat, cross: CGFloat) -> CGPoint {
        if direction == .Horizontal {
            return CGPointMake(stack, cross)
        }
        else {
            return CGPointMake(cross, stack)
        }
    }
}

/// MARK: - AAStackNodeChild

class AAStackNodeChild {
    var node: AAUINode!
    var spacingBefore: CGFloat =  0.0
    var spacingAfter: CGFloat =  0.0
    var flexGrow = false
    var flexShrink = false
    var alignSelf: AAStackNodeChildAlignment = .Auto
    
    class func newWithConfig(block: (AAStackNodeChild) -> Void) -> AAStackNodeChild {
        let o = AAStackNodeChild()
        block(o)
        return o
    }
    
    func node(node: AAUINode) -> Self {
        self.node = node
        return self
    }
    
    func spacingBefore(spacingBefore: CGFloat) -> Self {
        self.spacingBefore = spacingBefore
        return self
    }
    
    func spacingAfter(spacingAfter: CGFloat) -> Self {
        self.spacingAfter = spacingAfter
        return self
    }
    
    func alignSelf(alignSelf: AAStackNodeChildAlignment) -> Self {
        self.alignSelf = alignSelf
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
}

/// MARK: - AAStackNode

class AAStackNode: AAUINode {
    var direction: AAStackNodeDirection = .Horizontal
    var spacing: CGFloat = 0.0
    var alignItems: AAStackNodeAlignment = .End
    var children = [AAStackNodeChild]()
    
    func config(block: (AAStackNode) -> Void) -> Self {
        block(self)
        return self
    }
    
    func config(spacing spacing: CGFloat, alignItems: AAStackNodeAlignment) -> Self {
        return self.spacing(spacing).alignItems(alignItems)
    }
    
    func direction(direction: AAStackNodeDirection) -> Self {
        self.direction = direction
        return self
    }
    
    func spacing(spacing: CGFloat) -> Self {
        self.spacing = spacing
        return self
    }
    
    func alignItems(alignItems: AAStackNodeAlignment) -> Self {
        self.alignItems = alignItems
        return self
    }
    
    func children(children: [AAStackNodeChild]) -> Self {
        self.children = children
        return self
    }
    
    func child(child: AAStackNodeChild) -> Self {
        self.children.append(child)
        return self
    }
    
    func append(node: AAUINode) -> AAStackNodeChild {
        let child = AAStackNodeChild().node(node)
        self.children.append(child)
        return child
    }
    
    /// MARK: - calculate layout
    
    override func calculateSizeIfNeeded(constrainedSize: AASizeRange) {
        let stackSizeRange = AASizeRange(max: self.sizeRange.max.aa_min(constrainedSize.max))
        
        calculateChildrenSizesIfNeeded(stackSizeRange)
        
        size = CGSize.sizeWithStackCrossDimension(direction, stack: calculateStackDimension(), cross: calculateCrossDimension())
    }
    
    func calculateChildrenSizesIfNeeded(stackSizeRange: AASizeRange) {
        var usedStackSize: CGFloat = 0.0
        
        usedStackSize = layoutChildren(stackSizeRange, usedStackSize: usedStackSize, filter: { (child) -> (Bool) in
            return !child.flexShrink
        })
        
        usedStackSize = layoutChildren(stackSizeRange, usedStackSize: usedStackSize, filter: { (child) -> (Bool) in
            return child.flexShrink
        })
        
        flexChildrenAlongStackDimension(usedStackSize, stackSizeRange: stackSizeRange)
    }
    
    func flexChildrenAlongStackDimension(usedStackSize: CGFloat, stackSizeRange: AASizeRange) {
        let violation = computeViolation(direction, stackSizeRange: stackSizeRange, usedStackSize: usedStackSize)
        
        let kViolationEpsilon: CGFloat = 0.1;
        guard abs(violation) > kViolationEpsilon else {
            return
        }
        
        let flexChildren = self.flexChildren(violation)
        
        guard flexChildren.count > 0 else {
            return
        }
        
        let violationPerChild = violation / CGFloat(flexChildren.count)
        let remainViolation = violation - violationPerChild * CGFloat(flexChildren.count)
        
        var isFirstFlex = true
        for child in flexChildren {
            let shrink = isFirstFlex ? (violationPerChild + remainViolation) : violationPerChild
            child.node.size.shrinkStackDimension(direction, value: shrink)
            isFirstFlex = false
        }
    }
    
    func flexChildren(violation: CGFloat) -> [AAStackNodeChild] {
        return children.filter { (child) -> Bool in
            if violation > 0 && child.flexGrow {
                return true
            }
            if violation < 0 && child.flexShrink {
                return true
            }
            return false
        }
    }
    
    func computeViolation(direction: AAStackNodeDirection, stackSizeRange: AASizeRange, usedStackSize: CGFloat) -> CGFloat {
        let minStackDimension = stackSizeRange.min.stackDimension(direction)
        let maxStackDimension = stackSizeRange.max.stackDimension(direction)
        if (usedStackSize < minStackDimension) {
            return minStackDimension - usedStackSize
        }
        else if (usedStackSize > maxStackDimension) {
            return maxStackDimension - usedStackSize
        }
        else {
            return 0.0
        }
    }
    
    func layoutChildren(stackSizeRange:AASizeRange, usedStackSize: CGFloat, filter: (AAStackNodeChild) -> (Bool)) -> CGFloat {
        var usedStackSize = usedStackSize
        
        for child in children {
            usedStackSize += child.spacingBefore
            
            if !child.flexShrink {
                usedStackSize += layoutChild(child, stackSizeRange: stackSizeRange, usedStackSize: usedStackSize)
            }
            
            usedStackSize += spacing + child.spacingAfter
        }
        return usedStackSize
    }
    
    func layoutChild(child: AAStackNodeChild, stackSizeRange: AASizeRange, usedStackSize: CGFloat) -> CGFloat {
        let sizeRange = AASizeRange(max: stackSizeRange.max.shrinkStackDimension(direction, value: usedStackSize))
        child.node.calculateSizeIfNeeded(sizeRange)
        return child.node.size.stackDimension(direction)
    }
    
    override func calculateFrameIfNeeded() {
        super.calculateFrameIfNeeded()
        
        var stackPosition = position.stackOrigin(direction)
        let crossStart = position.crossOrigin(direction)
        for child in children {
            stackPosition += child.spacingBefore
            
            let crossPosition = crossPositionforChild(child) + crossStart
            
            child.node.position = CGPoint.pointWithStackCrossOrigin(direction, stack: stackPosition, cross: crossPosition)
            
            child.node.calculateFrameIfNeeded()
            
            stackPosition += child.node.size.stackDimension(direction) + spacing + child.spacingAfter
        }
    }
    
    func crossPositionforChild(child: AAStackNodeChild) -> CGFloat {
        switch child.alignSelf {
        case .Auto:
            return crossPositionForChild(child, alignment: alignItems)
        case .Start:
            return crossPositionForChild(child, alignment: .Start)
        case .Center:
            return crossPositionForChild(child, alignment: .Center)
        case .End:
            return crossPositionForChild(child, alignment: .End)
        case .Stretch:
            child.node.size.crossDimension(direction, cross: size.crossDimension(direction))
            return crossPositionForChild(child, alignment: .Start)
        }
    }
    
    func crossPositionForChild(child: AAStackNodeChild, alignment: AAStackNodeAlignment) -> CGFloat {
        switch alignment {
        case .Start:
            return CGFloat(0)
        case .Center:
            return (size.crossDimension(direction) - child.node.size.crossDimension(direction)) / 2.0
        case .End:
            return size.crossDimension(direction) - child.node.size.crossDimension(direction)
        }
    }
    
    func calculateStackDimension() -> CGFloat {
        var dim = CGFloat(0)
        var space = CGFloat(0)
        for child in children {
            dim += space + child.node.size.stackDimension(direction)
            space = spacing
        }
        return dim
    }
    
    func calculateCrossDimension() -> CGFloat {
        var dim = CGFloat(0)
        for child in children {
            dim = max(dim, child.node.size.crossDimension(direction))
        }
        return dim
    }
}

class AAHorizontalStackNode : AAStackNode {
    override init() {
        super.init()
        direction = .Horizontal
    }
}

class AAVerticalStackNode : AAStackNode {
    override init() {
        super.init()
        direction = .Vertical
    }
}


/// MARK: - static node, simply modify AAStackNode

class AAStaticNode : AAStackNode {
    init(size: CGSize) {
        self.staticSize = size
        super.init()
    }
    
    var staticSize: CGSize = CGSizeZero {
        didSet {
            sizeRange = AASizeRange(min: staticSize, max: staticSize)
        }
    }
    
    func staticSize(staticSize: CGSize) -> Self {
        self.staticSize = staticSize
        return self
    }
    
    override func calculateSizeIfNeeded(constrainedSize: AASizeRange) {
        let stackSizeRange = AASizeRange(max: self.sizeRange.max.aa_min(constrainedSize.max))
        calculateChildrenSizesIfNeeded(stackSizeRange)
        size = staticSize
    }
}

/// MARK: - inset node

class AAInsetNode: AAUINode {
    var child : AAUINode?
    var insets = UIEdgeInsetsZero
        
    init(insets: UIEdgeInsets) {
        self.insets = insets
        super.init()
    }
    
    func insets(insets: UIEdgeInsets) -> Self {
        self.insets = insets
        return self
    }
    
    func child(child: AAUINode) -> Self {
        self.child = child
        return self
    }
    
    override func calculateSizeIfNeeded(constrainedSize: AASizeRange) {
        let maxSize = self.sizeRange.max.aa_min(constrainedSize.max)
        
        let sizeRange = AASizeRange(max: maxSize.aa_insets(insets.aa_negate()).aa_nonnegative())
        
        child!.calculateSizeIfNeeded(sizeRange)
        size = child!.size.aa_insets(insets)
    }
    
    override func calculateFrameIfNeeded() {
        super.calculateFrameIfNeeded()
        
        child!.position.x = position.x + insets.left
        child!.position.y = position.y + insets.top
        
        child!.calculateFrameIfNeeded()
    }
}

extension AAUINode {
    func stackChild() -> AAStackNodeChild {
        return AAStackNodeChild().node(self)
    }
    
    func insetNode(insets: UIEdgeInsets) -> AAInsetNode {
        return AAInsetNode(insets: insets).child(self)
    }
}

/// MARK: - label node attributes

class AALabelAttributes {
    var text: String? = nil
    var attributedText: NSAttributedString? {
        get {
            return _attributedText != nil ? _attributedText : buildAttributedString(text)
        }
        set {
            _attributedText = newValue
        }
    }
    private var _attributedText: NSAttributedString? = nil
    
    var fontSize: CGFloat = 0.0
    var font: UIFont! {
        get {
            return _font != nil ? _font! : UIFont.systemFontOfSize(fontSize)
        }
        set {
            _font = newValue
        }
    }
    private var _font: UIFont?
    
    var hexColor: NSInteger = 0
    var textColor: UIColor! {
        get {
            return (_textColor != nil) ? _textColor! : UIColor.hexColor(self.hexColor)
        }
        set {
            _textColor = newValue
        }
    }
    private var _textColor: UIColor?
    
    var lineBreakMode = NSLineBreakMode.ByTruncatingTail
    var maximumNumberOfLines: Int = 0
    
    var alignment = NSTextAlignment.Left
    var firstLineHeadIndent: CGFloat = 0.0
    var headIndent: CGFloat = 0.0
    var tailIndent: CGFloat = 0.0
    var lineHeightMultiple: CGFloat = 0.0
    var maximumLineHeight: CGFloat = 0.0
    var minimumLineHeight: CGFloat = 0.0
    var lineSpacing: CGFloat = 0.0
    var paragraphSpacing: CGFloat = 0.0
    var paragraphSpacingBefore: CGFloat = 0.0
    
    func stringAttributes() -> Dictionary<String, AnyObject> {
        var attributes = [NSFontAttributeName: font,
                          NSForegroundColorAttributeName: textColor ]
        attributes[NSParagraphStyleAttributeName] = paragraphStyle()
        return attributes;
    }
    
    func paragraphStyle() -> NSParagraphStyle {
        let ps = NSMutableParagraphStyle()
        ps.alignment = alignment;
        ps.firstLineHeadIndent = firstLineHeadIndent;
        ps.headIndent = headIndent;
        ps.tailIndent = tailIndent;
        ps.lineHeightMultiple = lineHeightMultiple;
        ps.maximumLineHeight = maximumLineHeight;
        ps.minimumLineHeight = minimumLineHeight;
        ps.lineSpacing = lineSpacing;
        ps.paragraphSpacing = paragraphSpacing;
        ps.paragraphSpacingBefore = paragraphSpacingBefore;
        
        return ps;
    }
    
    func buildAttributedString(text: String?) -> NSAttributedString? {
        guard text != nil else {
            return nil
        }
        
        return NSAttributedString(string: text!, attributes: stringAttributes())
    }
}

extension AALabelAttributes {
    func text(text: String?) -> Self {
        self.text = text
        return self
    }
    
    func attributedText(attributedText: NSAttributedString?) -> Self {
        self.attributedText = attributedText
        return self
    }
    
    func font(font: UIFont?) -> Self {
        self.font = font
        return self
    }
    
    func fontSize(fontSize: CGFloat) -> Self {
        self.fontSize = fontSize
        return self
    }
    
    func hexColor(hexColor: NSInteger) -> Self {
        self.hexColor = hexColor
        return self
    }
    
    func textColor(textColor: UIColor?) -> Self {
        self.textColor = textColor
        return self
    }
    
    func lineBreakMode(lineBreakMode: NSLineBreakMode) -> Self {
        self.lineBreakMode = lineBreakMode
        return self
    }
    
    func maximumNumberOfLines(maximumNumberOfLines: Int) -> Self {
        self.maximumNumberOfLines = maximumNumberOfLines
        return self
    }
    
    func alignment(alignment: NSTextAlignment) -> Self {
        self.alignment = alignment
        return self
    }
    
    func firstLineHeadIndent(firstLineHeadIndent: CGFloat) -> Self {
        self.firstLineHeadIndent = firstLineHeadIndent
        return self
    }
    
    func headIndent(headIndent: CGFloat) -> Self {
        self.headIndent = headIndent
        return self
    }
    
    func tailIndent(tailIndent: CGFloat) -> Self {
        self.tailIndent = tailIndent
        return self
    }
    
    func lineHeightMultiple(text: CGFloat) -> Self {
        self.lineHeightMultiple = lineHeightMultiple
        return self
    }
    
    func maximumLineHeight(maximumLineHeight: CGFloat) -> Self {
        self.maximumLineHeight = maximumLineHeight
        return self
    }
    
    func minimumLineHeight(minimumLineHeight: CGFloat) -> Self {
        self.minimumLineHeight = minimumLineHeight
        return self
    }
    
    func lineSpacing(lineSpacing: CGFloat) -> Self {
        self.lineSpacing = lineSpacing
        return self
    }
    
    func paragraphSpacing(paragraphSpacing: CGFloat) -> Self {
        self.paragraphSpacing = paragraphSpacing
        return self
    }
    
    func paragraphSpacingBefore(paragraphSpacingBefore: CGFloat) -> Self {
        self.paragraphSpacingBefore = paragraphSpacingBefore
        return self
    }
}

/// MARK: - label node works for NIAttributedLabel only due to the size calculator

class AALabelNode: AAUINode {
    
    var config = AALabelAttributes()
    
    override func calculateSizeIfNeeded(constrainedSize: AASizeRange) {
        let maxSize = self.sizeRange.max.aa_min(constrainedSize.max)
        
        if config.attributedText != nil {
            size = NISizeOfAttributedStringConstrainedToSize(config.attributedText, maxSize, Int(config.maximumNumberOfLines))
        }
        else {
            size = CGSizeZero
        }
    }
    
    override func setup(view: UIView) {
        super.setup(view)
        
        // the size calculation only works for NIAttributedLabel
        // to use
        let label = view as! UILabel
        
        label.attributedText = config.attributedText
        
        label.lineBreakMode = config.lineBreakMode
        label.numberOfLines = Int(config.maximumNumberOfLines)
    }
}

extension AALabelNode {
    func config(fontSize fontSize: CGFloat, hexColor: NSInteger, text: String?) -> AALabelAttributes {
        self.config.fontSize(fontSize).hexColor(hexColor).text(text)
        return self.config
    }
}

/// MARK: - label node work for UILabel & its subclasses due to size calculator

class AAUILabelNode : AALabelNode {
    override func calculateSizeIfNeeded(constrainedSize: AASizeRange) {
        struct Sizer {
            static let sizeLabel = UILabel()
        }
        
        let maxSize = self.sizeRange.max.aa_min(constrainedSize.max)
        
        Sizer.sizeLabel.numberOfLines = Int(config.maximumNumberOfLines)
        Sizer.sizeLabel.attributedText = config.attributedText
        size = Sizer.sizeLabel.sizeThatFits(maxSize)
    }
}


