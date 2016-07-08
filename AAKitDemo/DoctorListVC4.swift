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
            let doctors = result.model as! [AnyObject!]
            
            let items = DoctorListItem.itemsWithDoctors(doctors)  as [AnyObject]
            
            if doctorListOptions.page == 0 {
                modelViewUpdater.reloadWithObjects(items)
            }
            else {
                modelViewUpdater.addObjectsFromArray(items)
            }
            
            if (doctors.count == doctorListOptions.pageSize) {
                self.doctorListOptions.page += 1;
            }
            
            refreshController.enableFooterRefresh()
        }
    }
}
