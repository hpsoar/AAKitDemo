//
//  HostViewVC.m
//  ComponentDemo
//
//  Created by HuangPeng on 6/30/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

#import "HostViewVC.h"
#import <ComponentKit/CKComponentProvider.h>
#import <ComponentKit/CKComponentHostingView.h>
#import "DoctorInfoComponent.h"
#import "CKComponent+HostingView.h"

@interface HostViewVC () 

@end

@implementation HostViewVC {
    DoctorModel *_doctor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _doctor = [DoctorModel new];
    _doctor.name = @"张三";
    _doctor.title = @"主任医师";
    _doctor.clinic = @"内科";
    _doctor.hospital = @"北医三院";
    _doctor.goodAt = @"你好SD罚点啥发生的发生sdfsdfasdfsadf的发生的发撒的发sadfdsafdsfsadf水电费撒旦法的说法的说法艺dafasdsdfsadfs术硕士艺术硕士艺术硕士爱迪生发生的发撒的发水电费大师发生的发生的发生的发生的发生的4333333333sdfsadfsadfsadfsad";
    
    CKComponentHostingView *hostingView = [DoctorInfoComponent hostingView:{
        .frame = CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 60),
        .sizeRangeFlexibility = CKComponentSizeRangeFlexibleHeight,
    }];
            
    [self.view addSubview:hostingView];
    [hostingView updateModel:_doctor mode:CKUpdateModeAsynchronous];
}

@end
