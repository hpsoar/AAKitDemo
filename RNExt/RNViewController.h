//
//  RNViewController.h
//  AAKitDemo
//
//  Created by HuangPeng on 7/11/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNNavigator.h"

@interface RNViewController : UIViewController

- (instancetype)initWithModule:(NSString *)moduleName parameters:(NSDictionary *)parameters;

- (instancetype)initWithContext:(RNNavigationContext *)context;

@end
