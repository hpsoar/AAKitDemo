//
//  DoctorInfoComponent.m
//  ComponentDemo
//
//  Created by HuangPeng on 6/30/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

#import "DoctorInfoComponent.h"
#import <ComponentKit/CKComponentSubclass.h>
#import "AALabelComponent.h"

@interface DoctorNameTitleComponent : CKCompositeComponent

+ (instancetype)newWithDoctor:(DoctorModel *)doctor;

@end

@implementation DoctorNameTitleComponent {
    
}

+ (instancetype)newWithDoctor:(DoctorModel *)doctor {   
    return [super newWithChild:{
        [CKStackLayoutComponent newWithView:{} size:{} style:{
            .direction = CKStackLayoutDirectionHorizontal,
            .spacing = 5,
            .alignItems = CKStackLayoutAlignItemsEnd,
        } children:{
            {   // name
                [AALabelComponent newWithLabelAttributes:{
                    .string = [NSString stringWithFormat:@"1点撒大是大非顺丰速递发撒的发撒的发水电费的时范德萨方是撒手富士达发生的 %@", doctor.name],
                    .font = [UIFont systemFontOfSize:16],
                    .color = [UIColor redColor],
                } viewAttributes:{} size:{}],
            },
            {   // title
                [AALabelComponent newWithLabelAttributes:{
                    .string = doctor.title,
                    .font = [UIFont systemFontOfSize:12],
                    .color = [UIColor blueColor],
                } viewAttributes:{} size:{}],
            }
        }],
    }];
}

@end

@interface DoctorClinicHospitalComponent : CKCompositeComponent

+ (instancetype)newWithDoctor:(DoctorModel *)doctor;

@end

@implementation DoctorClinicHospitalComponent {
    DoctorModel *_doctor;
}

+ (id)initialState {
    return @NO;
}

+ (instancetype)newWithDoctor:(DoctorModel *)doctor {
    CKComponentScope scope(self);
    
    DoctorClinicHospitalComponent *c = [super newWithChild:{
        [CKStackLayoutComponent newWithView:{} size:{} style:{
            .direction = CKStackLayoutDirectionHorizontal,
            .spacing = 5,
            .alignItems = CKStackLayoutAlignItemsEnd,
        }children:{
            {   // clinic
                [CKLabelComponent newWithLabelAttributes:{
                    .string = doctor.clinic,
                    .font = [UIFont systemFontOfSize:12],
                    .color = [UIColor blackColor],
                }viewAttributes:{} size:{}],
            },
            {   // hospital
                [CKLabelComponent newWithLabelAttributes:{
                    .string = doctor.hospital,
                    .font = [UIFont systemFontOfSize:12],
                    .color = [UIColor blackColor],
                }viewAttributes:{} size:{}]
            },           
            {   helloBtn(), },
        }],
    }];
    
    c->_doctor = doctor;
    
    return c;
}

static CKComponent *helloBtn() {
    return [CKButtonComponent newWithTitles:{
        { UIControlStateNormal, @"hello" },
    }titleColors:{
        { UIControlStateNormal, [UIColor greenColor], }
    }images:{} backgroundImages:{} titleFont:{} selected:NO enabled:YES action:@selector(tap:) size:{
        .width = 80,
        .height = 30
    } attributes:{
        { @selector(setBackgroundColor:), [UIColor lightGrayColor] },
        { CKComponentViewAttribute::LayerAttribute(@selector(setCornerRadius:)), @4 },
    } accessibilityConfiguration:{}];
}

- (void)tap:(id)sender {
    _doctor.goodAt = [MockDoctorModelDataSource randomGoodAt];
    [self updateState:^id(id oldState) {
        return [oldState boolValue] ? @NO : @YES;
    } mode:CKUpdateModeAsynchronous];
}

@end

@implementation DoctorInfoComponent

+ (instancetype)newWithDoctor:(DoctorModel *)doctor {
    CKComponentScope scope(self);
    
    return [super newWithView:{
        [UIView class],
        {
            { @selector(setBackgroundColor:), [UIColor whiteColor] },
            { @selector(setClipsToBounds:), YES },
        }
    } child:{
        [CKStackLayoutComponent newWithConfig:{
            .children = {
                {   // body                    
                    [CKInsetComponent newWithView:{} insets:UIEdgeInsetsMake(5, 10, 5, 10) child:{
                        [CKStackLayoutComponent newWithView:{} size:{} style:{
                            .spacing = 8,
                        }children:{
                            {   // name & title
                                [DoctorNameTitleComponent newWithDoctor:doctor],
                            },
                            {   // clinic & hospital
                                [DoctorClinicHospitalComponent newWithDoctor:doctor],
                            },
                            {   // good at
                                [CKLabelComponent newWithLabelAttributes:{
                                    .string = doctor.goodAt,
                                    .font = [UIFont systemFontOfSize:12],
                                    .color = [UIColor grayColor],
                                    .maximumNumberOfLines = 2,
                                    .truncationString = @"...",
                                    .lineHeightMultiple = 1.2,
                                }viewAttributes:{} size:{}],
                            },
                        }]
                    }]
                },
                {   // sep
                    .spacingBefore = 10,
                    .component = hairlineComponent(),
                },
            }
        }]
    }];
}

static CKComponent *hairlineComponent()
{
    return [CKComponent
            newWithView:{
                [UIView class],
                {
                    {@selector(setBackgroundColor:), [UIColor lightGrayColor]},
                    {@selector(setAutoresizingMask:), UIViewAutoresizingFlexibleWidth }
                }
            }
            size:{
                .height = 1/[UIScreen mainScreen].scale,
                .minWidth = 700,
            }];
}

+ (CKComponent *)componentForModel:(id)doctor context:(id<NSObject>)context {
    return [self newWithDoctor:doctor];
}

@end

@implementation DoctorModel (ComponentFactory)

- (CKComponent *)componentWithContext:(id<NSObject>)context {
    return [DoctorInfoComponent componentForModel:self context:context];
}

@end
