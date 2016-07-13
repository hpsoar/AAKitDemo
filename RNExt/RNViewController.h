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

- (instancetype)initWithContext:(RNNavigationContext *)context bridge:(RCTBridge *)bridge;

@end
