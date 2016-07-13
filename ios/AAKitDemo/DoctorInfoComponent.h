//
//  DoctorInfoComponent.h
//  ComponentDemo
//
//  Created by HuangPeng on 6/30/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

#import "DoctorModel.h"

#import "AAComponentExt.h"

@interface DoctorInfoComponent : CKCompositeComponent

+ (instancetype)newWithDoctor:(DoctorModel *)doctor;


@end

@interface DoctorModel (ComponentFactory) <ComponentModelProtocol>

@end
