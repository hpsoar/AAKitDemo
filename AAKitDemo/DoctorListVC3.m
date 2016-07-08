//
//  DoctorListVC3.m
//  ComponentDemo
//
//  Created by HuangPeng on 7/4/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

#import "DoctorListVC3.h"
#import "DoctorModel.h"
#import "AAKitDemo-Swift.h"

@interface DoctorListVC3 ()
@property(nonatomic, strong) DoctorListOptions *doctorListOptions;
@end

@implementation DoctorListVC3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.doctorListOptions = [DoctorModel doctorListOptions];
    self.modelRefresher.modelOptions = self.doctorListOptions;
    self.modelRefresher.modelController =
    [AAModelController newWithDataSource:[MockDoctorModelDataSource new]];
    
    [self.refreshController enableHeaderRefresh];
    
    [self.modelRefresher refresh:ModelRefreshTypeTop];
}

- (void)refresher:(AAModelRefresher *)refresher
didFinishLoadWithType:(ModelRefreshType)type
           result:(AAModelResult *)result {
    if (result.error) {
        
    } else {
        NSArray *doctors = result.model;
        if (doctors.count > 0) {
            NSArray *items = [DoctorListItem itemsWithDoctors:doctors];
            if (self.doctorListOptions.page == 0) {
                [self.modelViewUpdater reloadWithObjects:items];
            }
            else {
                [self.modelViewUpdater addObjectsFromArray:items];
            }
        }
        
        if (doctors.count == self.doctorListOptions.pageSize) {
            self.doctorListOptions.page += 1;
        }                
        
        [self.refreshController enableFooterRefresh];
    }
}

@end
