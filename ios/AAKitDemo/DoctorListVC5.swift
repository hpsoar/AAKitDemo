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
        
        // automatically add nodes referrenced in layoutSpec
        // http://asyncdisplaykit.org/docs/implicit-hierarchy-mgmt.html
        self.usesImplicitHierarchyManagement = true
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
    
    let btn: ASButtonNode = ASButtonNode()
    
    let dumb: ASDisplayNode = ASDisplayNode()
    
    let line = ASDisplayNode(viewBlock: { () -> UIView in
        return UIView().aa_backgroundHexColor(0xcccccc)
    }).preferredFrameSize(CGSizeMake(CGFloat.max, 0.5))
    
    init(doctor: DoctorModel) {
        self.doctor = doctor
        
        super.init()
        
        nameNode.style(asd_textStyle(fontSize: 16, hexColor: 0xff0000, text: doctor.name))
        
        titleNode.style(asd_textStyle(fontSize: 12, hexColor: 0x00ff00, text: doctor.title))
            .flexShrink(true).maximumNumberOfLines(1)
        
        clinicNode.style(asd_textStyle(fontSize: 12, hexColor: 0x666666, text: doctor.clinic))
        
        hospitalNode.style(asd_textStyle(fontSize: 12, hexColor: 0x666666, text: doctor.hospital))
        
        goodAtNode.style(asd_textStyle(fontSize: 12, hexColor: 0x666666, text: doctor.goodAt))
            .maximumNumberOfLines(2)
        
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
        
        addSubnodes([
            figureNode,
            nameNode,
            titleNode,
            clinicNode,
            hospitalNode,
            goodAtNode,
            btn,
            line,
            //dumb
            ])
        
        displaysAsynchronously(false)
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