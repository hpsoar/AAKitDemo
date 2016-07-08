//
//  DoctorListVC4.swift
//  ComponentDemo
//
//  Created by HuangPeng on 7/6/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

import UIKit

class DoctorListVC4 : NITableVC {
    let doctorListOptions = DoctorModel.doctorListOptions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modelRefresher.modelOptions = self.doctorListOptions
        
        modelRefresher.modelController = AAModelController(dataSource: MockDoctorModelDataSource())
        
        refreshController.enableHeaderRefresh()
        
        modelRefresher.refresh(.Top)
    }
    
    override func refresher(refresher: AAModelRefresher!, didFinishLoadWithType type: ModelRefreshType, result: AAModelResult!) {
        if result.error != nil {
            
        }
        else {
            if doctorListOptions.page == 0 {
                modelViewUpdater.removeSectionAtIndex(0)
            }
            
            let doctors = result.model as! [AnyObject!]
            if (doctors.count > 0) {
                modelViewUpdater.addObjectsFromArray(DoctorListItem.itemsWithDoctors(doctors)  as [AnyObject])
            }
            
            if (doctors.count == doctorListOptions.pageSize) {
                self.doctorListOptions.page += 1;
            }
            
            refreshController.enableFooterRefresh()
        }
    }
}
