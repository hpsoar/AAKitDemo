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
        
        nameNode.style(fontSize: 16, hexColor: 0xff0000, text: doctor.name).applyStyle()
        
        titleNode.style(fontSize: 12, hexColor: 0x00ff00, text: doctor.title)
            .flexShrink(true).maximumNumberOfLines(1).applyStyle()
        
        clinicNode.style(fontSize: 12, hexColor: 0x666666, text: doctor.clinic).applyStyle()
        hospitalNode.style(fontSize: 12, hexColor: 0x666666, text: doctor.hospital).applyStyle()
        
        goodAtNode.style(fontSize: 12, hexColor: 0x666666, text: doctor.goodAt)
            .maximumNumberOfLines(2).applyStyle()
        
        figureNode.preferredFrameSize(CGSizeMake(45, 45))
            .URL("http://i.imgur.com/FjOR9kX.jpg")
        
        addSubnodes([
            figureNode,
            nameNode,
            titleNode,
            clinicNode,
            hospitalNode,
            goodAtNode
            ])
        
        //displaysAsynchronously(true)
    }
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return [
            [
                figureNode.asInsets(UIEdgeInsetsMake(5, 0, 0, 10)),
                [
                    [nameNode, titleNode].asHStack().spacing(5).alignItems(.End),
                    [clinicNode, hospitalNode].asHStack().alignItems(.End).spacing(5),
                    goodAtNode as ASLayoutable,
                ].asVStack().spacing(5).flexShrink(true)
            ].asHStack().asInsets(UIEdgeInsetsMake(10, 10, 10, 10)),
            
            ASDisplayNode(viewBlock: { () -> UIView in
                return UIView().aa_hexBackColor(0xcccccc)
            }) as ASLayoutable
            
            ].asVStack().spacing(5)
    }
}
