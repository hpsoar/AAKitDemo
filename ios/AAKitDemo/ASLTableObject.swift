//
//  ASLTableObject.swift
//  AAKitDemo
//
//  Created by HuangPeng on 7/12/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

import UIKit

extension ASDisplayNode {
    func bind(v: UIView) -> Self {
        v.frame = self.frame
        return self
    }
}

class ASLabelNode : ASDisplayNode {
    override func bind(v: UIView) -> Self {
        super.bind(v)
        
        // the size calculation only works for NIAttributedLabel
        // to use
        let label = v as! UILabel
        
        label.attributedText = config.attributedText
        
        label.lineBreakMode = config.lineBreakMode
        label.numberOfLines = Int(config.maximumNumberOfLines)
        
        return self
    }
    
    override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {
        struct Sizer {
            static let sizeLabel = UILabel()
        }
        
        Sizer.sizeLabel.numberOfLines = Int(config.maximumNumberOfLines)
        Sizer.sizeLabel.attributedText = config.attributedText
        return Sizer.sizeLabel.sizeThatFits(constrainedSize)
    }
    
    func style(style: AALabelAttributes) -> Self {
        config = style
        return self
    }
    
    var config = AALabelAttributes()
}

class DoctorListItem3: AATableObject {
    class func itemsWithDoctors(doctors: NSArray) -> NSArray {
        return doctors.aa_map({ (obj, idx) -> AnyObject? in
            let item = DoctorListItem3()
            item.doctor = obj as! DoctorModel
            return item
        })
    }
    
    var doctor: DoctorModel!
    
    override func cellClass() -> AnyClass! {
        return DoctorListItemCell3.self
    }
    
    var rootNode: ASDoctorInfoNode2!
    
    override func layoutForItem(item: AnyObject!, indexPath: NSIndexPath!, tableView: UITableView!) {
        if (rootNode == nil) {
            rootNode = ASDoctorInfoNode2(doctor: doctor)
            rootNode .asd_layout(width: tableView.width)
            cellHeight = rootNode.calculatedSize.height
        }
    }        
}

class ASDoctorInfoNode2 : ASDisplayNode {
    class func itemsWithDoctors(doctors: [DoctorModel]) -> [ASDoctorInfoNode2] {
        return doctors.map({ (d) -> ASDoctorInfoNode2 in
            return ASDoctorInfoNode2(doctor: d)
        })
    }
    
    let doctor: DoctorModel
    let nameNode = ASLabelNode()
    let titleNode = ASLabelNode()
    let figureNode = ASNetworkImageNode()
    let clinicNode = ASLabelNode()
    let hospitalNode = ASLabelNode()
    let goodAtNode = ASLabelNode()
    
    let btn: ASButtonNode = ASButtonNode()
    
    let dumb: ASDisplayNode = ASDisplayNode()
    
    let line = ASDisplayNode(viewBlock: { () -> UIView in
        return UIView().aa_backgroundHexColor(0xcccccc)
    }).preferredFrameSize(CGSizeMake(CGFloat.max, 0.5))
    
    init(doctor: DoctorModel) {
        self.doctor = doctor
        
        super.init()
        
        nameNode.style(asd_textStyle(fontSize: 16, hexColor: 0xff0000, text: doctor.name))
        
        titleNode.style(
            asd_textStyle(fontSize: 12, hexColor: 0x00ff00, text: doctor.title).maximumNumberOfLines(1)
            ).flexShrink(true)
        
        clinicNode.style(asd_textStyle(fontSize: 12, hexColor: 0x666666, text: doctor.clinic))
        
        hospitalNode.style(asd_textStyle(fontSize: 12, hexColor: 0x666666, text: doctor.hospital))
        
        goodAtNode.style(
            asd_textStyle(fontSize: 12, hexColor: 0x666666, text: doctor.goodAt).maximumNumberOfLines(2)
        )
        
        figureNode.preferredFrameSize(CGSizeMake(45, 45))
            .URL("http://i.imgur.com/FjOR9kX.jpg")
        
        btn.title("hello", fontSize: 14, hexColor: 0x0000ff, forState: .Normal)
            .border(width: 1, hexColor: 0xff0000, cornerRadius: 4)
            .contentEdgeInsets(UIEdgeInsetsMake(3, 5, 3, 5))
            .userInteractionEnabled(true)
            .addTarget(self, action: #selector(test(_:)), forControlEvents: .TouchUpInside)
        
        // automatically add nodes referrenced in layoutSpec
        // http://asyncdisplaykit.org/docs/implicit-hierarchy-mgmt.html
        self.usesImplicitHierarchyManagement = true
        
        displaysAsynchronously(true)
    }
    
    func test(sender: AnyObject) {
        NSLog("%@", "hello")
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return asd_vStack().alignItems(.Stretch).spacing(5).children([
            asd_insets(top: 10, left: 10, bottom: 10, right: 10).child(
                asd_hStack().children([
                    asd_insets(top: 5, left: 0, bottom: 0, right: 10).child(
                        figureNode
                    ),
                    // or
                    // figureNode.asInsets(top: 5, left: 0, bottom: 0, right: 10),
                    
                    asd_vStack().alignItems(.Stretch).spacing(5).flexGrow(true).flexShrink(true).children([
                        asd_hStack().spacing(5).alignItems(.End).children([
                            nameNode,
                            titleNode.flexGrow(true),
                            btn
                            ]),
                        
                        asd_hStack().alignItems(.End).spacing(5).children([
                            clinicNode,
                            hospitalNode
                            ]),
                        goodAtNode,
                        dumb,
                        ])
                    ])
            ),
            line
            ])
    }
}

class DoctorListItemCell3: AATableCell {
    let nameLabel = UILabel()
    let titleLabel = UILabel()
    let figureView = UIImageView()
    let clinicLabel = UILabel()
    let hospitalLabel = UILabel()
    let goodAtLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.aa_addSubviews([
            nameLabel,
            titleLabel,
            figureView,
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
        
        let item = object as! DoctorListItem3
        
        let root = item.rootNode
        root.nameNode.bind(nameLabel)
        root.titleNode.bind(titleLabel)
        root.figureNode.bind(figureView)
        root.clinicNode.bind(clinicLabel)
        root.hospitalNode.bind(hospitalLabel)
        root.goodAtNode.bind(goodAtLabel)
        
        return true
    }
}
