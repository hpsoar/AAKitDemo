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
    var rootNode: AAStackNode
    
    init() {
        nameNode.style.textColor = UIColor.redColor()
        nameNode.style.fontSize = 16
        
        titleNode.style.textColor = UIColor.grayColor()
        titleNode.style.fontSize = 12
        
        clinicNode.style.fontSize = 12
        clinicNode.style.hexColor = 0x439322
        
        hospitalNode.style.fontSize = 12
        hospitalNode.style.textColor = UIColor.grayColor()
        
        goodAtNode.style.fontSize = 12
        goodAtNode.style.textColor = UIColor.grayColor()
        goodAtNode.style.maximumNumberOfLines = 2
        
        rootNode = AAStackNode()
            .direction(.Vertical)
            .spacing(5)
            .alignItems(.Start)
            .children([
            AAStackNodeChild()
                .node(AAInsetNode()
                    .insets(UIEdgeInsetsMake(10, 10, 10, 10))
                    .child(AAStackNode()
                        .direction(.Vertical)
                        .spacing(5)
                        .alignItems(.Start)
                        .children([
                            AAStackNodeChild()
                                .node(AAStackNode()
                                .alignItems(.End)
                                .spacing(5)
                                .direction(.Horizontal)
                                .children([
                                    AAStackNodeChild().node(nameNode),
                                    AAStackNodeChild().node(titleNode),
                                ])
                            ),
                            AAStackNodeChild()
                                .node(AAStackNode()
                                .alignItems(.End)
                                .spacing(5)
                                .direction(.Horizontal)
                                .children([
                                    AAStackNodeChild().node(clinicNode),
                                    AAStackNodeChild().node(hospitalNode)
                                    ])
                                ),
                            AAStackNodeChild().node(goodAtNode)
                        ])
                    )
                    )
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
    let layout = DoctorListLayout()

    override func layoutForItem(item: AnyObject!, indexPath: NSIndexPath!, tableView: UITableView!) {
        //let doctorListItem = item as! DoctorListItem
        let doctor = (item as! DoctorListItem).doctor
        layout.nameNode.text = doctor.name
        layout.titleNode.text = doctor.title
        layout.clinicNode.text = doctor.clinic
        layout.hospitalNode.text = doctor.hospital
        layout.goodAtNode.text = doctor.goodAt
        
        let contrainedSize = AASizeRange(max: CGSizeMake(tableView.width, CGFloat.max))
        layout.layoutIfNeeded(contrainedSize)
        cellHeight = layout.rootNode.size.height
    }
}

class DoctorListItemCell : AATableCell {
    let nameLabel = NIAttributedLabel()
    let titleLabel = NIAttributedLabel()
    let clinicLabel = NIAttributedLabel()
    let hospitalLabel = NIAttributedLabel()
    let goodAtLabel = NIAttributedLabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.aa_addSubviews([
            nameLabel,
            titleLabel,
            clinicLabel,
            hospitalLabel,
            goodAtLabel,
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func shouldUpdateCellWithObject(object: AnyObject!) -> Bool {
        super.shouldUpdateCellWithObject(object)
        
        let item = object as! DoctorListItem
        
        item.layout.nameNode.setup(nameLabel)
        item.layout.titleNode.setup(titleLabel)
        item.layout.clinicNode.setup(clinicLabel)
        item.layout.hospitalNode.setup(hospitalLabel)
        item.layout.goodAtNode.setup(goodAtLabel)
        
        return true
    }
}
