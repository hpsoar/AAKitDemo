//
//  DoctorLIstCatalog.swift
//  ComponentDemo
//
//  Created by HuangPeng on 7/6/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

import UIKit

class DoctorListLayout {
    var nameNode = AALabelNode()
    var titleNode = AALabelNode()
    var clinicNode = AALabelNode()
    var hospitalNode = AALabelNode()
    var goodAtNode = AALabelNode()
    var figureNode = AAStaticNode(size: CGSizeMake(45, 45))
    var rootNode: AAStackNode!
    var btnNode = AAButtonNode(preferredSize: CGSizeMake(80, 30))
    
    convenience init() {
        self.init(doctor: nil)
    }
    
    init(doctor: DoctorModel?) {
        nameNode.config(fontSize: 16, hexColor: 0xff0000, text: doctor?.name)
        
        titleNode.config(fontSize: 12, hexColor: 0x666666, text: doctor?.title)
        
        clinicNode.config(fontSize: 12, hexColor: 0x439322, text: doctor?.clinic)
        
        hospitalNode.config(fontSize: 12, hexColor: 0x666666, text: doctor?.hospital)
        
        goodAtNode.config(fontSize: 12, hexColor: 0x666666, text: doctor?.goodAt)
            .maximumNumberOfLines(2)
        
        btnNode.styleBlock { (btn) in
            btn.aa_config(font: UIFont.systemFontOfSize(14), hexColor: 0xff0000, title: "hello")
               .aa_border(width: 1, hexColor: 0x00ff00, cornerRadius: 4)
        }
        
        rootNode = AAVerticalStackNode().config(spacing: 5, alignItems: .Start).children([
            AAHorizontalStackNode().children([
                figureNode.insetNode(UIEdgeInsetsMake(10, 10, 0, 20)).stackChild(),
                
                AAVerticalStackNode().config(spacing: 5, alignItems: .Start).children([
                    AAHorizontalStackNode().config(spacing: 5, alignItems: .End).children([
                        self.nameNode.stackChild(),
                        self.titleNode.stackChild().flexShrink(true).flexGrow(true),
                        self.btnNode.stackChild(),
                        ]).stackChild(),
                    
                    AAHorizontalStackNode().config(spacing: 5, alignItems: .End).children([
                        self.clinicNode.stackChild(),
                        self.hospitalNode.stackChild(),
                        ]).stackChild(),
                    
                    goodAtNode.stackChild(),
                    
                    ]).stackChild()
                
                ]).insetNode(UIEdgeInsetsMake(10, 10, 10, 10)).stackChild(),
                // TODO: add line
            ])
    }
    
    func layoutIfNeeded(constrainedSize: AASizeRange) {
        rootNode.layoutIfNeeded(constrainedSize)
    }
}

class DoctorListItem: AATableObject {
    let doctor : DoctorModel!
    
    class func itemsWithDoctors(doctors: NSArray) -> NSArray {
        return doctors.aa_map({ (obj, idx) -> AnyObject? in
            return DoctorListItem(doctor: obj as! DoctorModel)
        })
    }
    
    init(doctor: DoctorModel!) {
        self.doctor = doctor
        super.init()
    }
    
    override func cellClass() -> AnyClass! {
        return DoctorListItemCell.self
    }
    
/// MARK - layout
    var layout: DoctorListLayout!
    var lastSize = CGSizeZero

    override func layoutForItem(item: AnyObject!, indexPath: NSIndexPath!, tableView: UITableView!) {
        if layout == nil || lastSize.width != tableView.width {
            let doctor = (item as! DoctorListItem).doctor
        
            layout = DoctorListLayout(doctor: doctor)
        
            let contrainedSize = AASizeRange(max: CGSizeMake(tableView.width, CGFloat.max))
            layout.layoutIfNeeded(contrainedSize)
            cellHeight = layout.rootNode.size.height
            
            lastSize = tableView.size
        }
    }
}

class DoctorListItemCell : AATableCell {
    override func shouldUpdateCellWithObject(object: AnyObject!) -> Bool {
        super.shouldUpdateCellWithObject(object)
        
        let item = object as! DoctorListItem
        item.layout.rootNode.mountOnView(contentView)
        
        return true
    }
    
    override func prepareForReuse() {
        contentView.aa_removeAllSubviews()
    }
}

class DoctorListItem2: ASNodeObject {
    let doctor : DoctorModel!
    
    class func itemsWithDoctors(doctors: NSArray) -> NSArray {
        return doctors.aa_map({ (obj, idx) -> AnyObject? in
            return DoctorListItem2(doctor: obj as! DoctorModel)
        })
    }
    
    init(doctor: DoctorModel!) {
        self.doctor = doctor
        super.init(rootNode: ASDoctorInfoNode(doctor: doctor))
        //rootNode.displaysAsynchronously = false
    }
    
}

class ASNodeObject: AATableObject {
    override func cellClass() -> AnyClass! {
        return ASNodeCell.self
    }
    
    init(rootNode: ASDisplayNode) {
        self.rootNode = rootNode
        super.init()
    }
    
    var layout: ASLayout!
    var rootNode: ASDisplayNode
    
    override func layoutForItem(item: AnyObject!, indexPath: NSIndexPath!, tableView: UITableView!) {
        if layout == nil {
            let sizeRange = ASSizeRangeMake(CGSizeZero, CGSizeMake(tableView.width, CGFloat.max))
            layout = rootNode.measureWithSizeRange(sizeRange)
            rootNode.layout()
            cellHeight = rootNode.calculatedSize.height            
        }
    }

}

class ASNodeCell: AATableCell {
    override func shouldUpdateCellWithObject(object: AnyObject!) -> Bool {
        super.shouldUpdateCellWithObject(object)
        
        let item = object as! ASNodeObject
        contentView.addSubnode(item.rootNode)
        
        return true
    }
    
    override func prepareForReuse() {
        contentView.aa_removeAllSubviews()
    }
}
