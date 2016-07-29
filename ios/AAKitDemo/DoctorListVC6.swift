//
//  DoctorListVC6.swift
//  AAKitDemo
//
//  Created by HuangPeng on 7/12/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

import UIKit

class DoctorListVC6: NITableVC {

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
            
            let items = DoctorListItem3.itemsWithDoctors(doctors)  as [AnyObject]
            
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
        tableView.reloadData()
    }
}
