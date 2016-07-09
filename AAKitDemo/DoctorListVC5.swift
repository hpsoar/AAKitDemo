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
            
            let items = ASDoctorInfoNode.itemsWithDoctors(doctors as! [DoctorModel])
            
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

class ASDoctorInfoNode : ASCellNode {
    class func itemsWithDoctors(doctors: [DoctorModel]) -> [ASDoctorInfoNode] {
        return doctors.map({ (d) -> ASDoctorInfoNode in
            return ASDoctorInfoNode(doctor: d)
        })
    }
    
    let doctor: DoctorModel
    let nameNode: ASTextNode
    let titleNode: ASTextNode
    let figureNode: ASNetworkImageNode
//    let clinicNode: ASTextNode
//    let hospitalNode: ASTextNode
//    let btn: ASButtonNode
    
    init(doctor: DoctorModel) {
        self.doctor = doctor
        
        nameNode = ASTextNode()
        nameNode.attributedText = attributedString(doctor.name, fontSize: 16, color: 0xff0000)
        
        titleNode = ASTextNode()
        titleNode.attributedText = attributedString(doctor.title, fontSize: 12, color: 0x00ff00)        
        
        figureNode = ASNetworkImageNode()
        figureNode.URL = NSURL(string: "http://i.imgur.com/FjOR9kX.jpg")
        figureNode.preferredFrameSize = CGSizeMake(45, 45)
        
        super.init()
        
        addSubnode(nameNode)
        addSubnode(titleNode)
        addSubnode(figureNode)
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let nameTitle = ASStackLayoutSpec(direction: .Horizontal, spacing: 5, justifyContent: .Start, alignItems: .End, children: [
            nameNode, titleNode
            ])
        
        let vStack = ASStackLayoutSpec(direction: .Vertical, spacing: 5, justifyContent: .Start, alignItems: .Start, children: [
            nameTitle
            ])
        
        let contentStack = ASStackLayoutSpec(direction: .Horizontal, spacing: 0, justifyContent: .Start, alignItems: .Start, children: [
            figureNode, vStack,
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
