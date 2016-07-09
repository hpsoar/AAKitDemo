//
//  DoctorListVC5.swift
//  AAKitDemo
//
//  Created by HuangPeng on 7/9/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

import UIKit

class DoctorListVC5: ASTableVC {
    
    let doctorListOptions = DoctorModel.doctorListOptions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modelRefresher.modelOptions = self.doctorListOptions
        
        modelRefresher.modelController = AAModelController(dataSource: MockDoctorModelDataSource())
        
        refreshController.enableHeaderRefresh()
        
        modelRefresher.refresh(.Top)                
    }
    
    func refresher(refresher: AAModelRefresher!, didFinishLoadWithType type: ModelRefreshType, result: AAModelResult!) {
        if result.error != nil {
            
        }
        else {
            let doctors = result.model as! [AnyObject!]
            
            let items = ASDoctorInfoCellNode.itemsWithDoctors(doctors as! [DoctorModel])
            
            if doctorListOptions.page == 0 {
                modelViewUpdater.reloadWithObjects(items)
            }
            else {
                modelViewUpdater.appendObjects(items)
            }
            
            if (doctors.count == doctorListOptions.pageSize) {
                self.doctorListOptions.page += 1;
            }
            
            refreshController.enableFooterRefresh()
        }
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        tableNode.view.relayoutItems()
    }

}

func attributedString(text: String, fontSize: CGFloat, color: NSInteger) -> NSAttributedString {
    let d = [ NSFontAttributeName: UIFont.systemFontOfSize(fontSize),
              NSForegroundColorAttributeName: UIColor.hexColor(color)]
    return NSAttributedString(string: text, attributes: d)
}

class ASDoctorInfoCellNode: ASCellNode {
    class func itemsWithDoctors(doctors: [DoctorModel]) -> [ASDoctorInfoCellNode] {
        return doctors.map({ (d) -> ASDoctorInfoCellNode in
            return ASDoctorInfoCellNode(doctor: d)
        })
    }
    
    let node: ASDisplayNode
    
    init(doctor: DoctorModel) {
        node = ASDoctorInfoNode(doctor: doctor)
        super.init()
        
        for n in node.subnodes {
            addSubnode(n)
        }
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return node.layoutSpecThatFits(constrainedSize)
    }
}

class ASDoctorInfoNode : ASDisplayNode {
    class func itemsWithDoctors(doctors: [DoctorModel]) -> [ASDoctorInfoNode] {
        return doctors.map({ (d) -> ASDoctorInfoNode in
            return ASDoctorInfoNode(doctor: d)
        })
    }
    
    let doctor: DoctorModel
    let nameNode = ASTextNode()
    let titleNode = ASTextNode()
    let figureNode = ASNetworkImageNode()
    let clinicNode = ASTextNode()
    let hospitalNode = ASTextNode()
    let goodAtNode = ASTextNode()
    
    //let btn: ASButtonNode
    
    init(doctor: DoctorModel) {
        self.doctor = doctor
        
        super.init()
        
        nameNode.attributedText = attributedString(doctor.name, fontSize: 16, color: 0xff0000)
        
        titleNode.attributedText = attributedString(doctor.title, fontSize: 12, color: 0x00ff00)
        titleNode.flexShrink = true
        titleNode.maximumNumberOfLines = 1
        
        clinicNode.attributedText = attributedString(doctor.clinic, fontSize: 12, color: 0x666666)
        
        hospitalNode.attributedText = attributedString(doctor.hospital, fontSize: 12, color: 0x666666)
        
        goodAtNode.attributedText = attributedString(doctor.goodAt, fontSize: 12, color: 0x666666)
        goodAtNode.maximumNumberOfLines = 2
        
        figureNode.URL = NSURL(string: "http://i.imgur.com/FjOR9kX.jpg")
        figureNode.preferredFrameSize = CGSizeMake(45, 45)
        
        addSubnode(figureNode)
        addSubnode(nameNode)
        addSubnode(titleNode)
        addSubnode(clinicNode)
        addSubnode(hospitalNode)
        addSubnode(goodAtNode)        
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let nameTitle = ASStackLayoutSpec(direction: .Horizontal, spacing: 5, justifyContent: .Start, alignItems: .End, children: [
            nameNode, titleNode
            ])
        
        let clinicHospital = ASStackLayoutSpec(direction: .Horizontal, spacing: 5, justifyContent: .Start, alignItems: .End, children: [
            clinicNode, hospitalNode
            ])
        
        let vStack = ASStackLayoutSpec(direction: .Vertical, spacing: 5, justifyContent: .Start, alignItems: .Start, children: [
            nameTitle,
            clinicHospital,
            goodAtNode,
            ])
        vStack.flexShrink = true
        
        let contentStack = ASStackLayoutSpec(direction: .Horizontal, spacing: 0, justifyContent: .Start, alignItems: .Start, children: [
            ASInsetLayoutSpec(insets: UIEdgeInsetsMake(5, 0, 0, 10), child: figureNode),
            vStack,
            ])
        
        let contentSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 10, 10, 10), child: contentStack)
        
        let sep = ASDisplayNode { () -> UIView in
            return UIView().aa_hexBackColor(0xcccccc)
        }
        
        let mainStack = ASStackLayoutSpec(direction: .Vertical, spacing: 5, justifyContent: .Start, alignItems: .Start, children: [
            contentSpec,
            sep
            ])
        
        return mainStack
    }
}
