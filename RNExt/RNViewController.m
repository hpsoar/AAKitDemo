//
//  RNViewController.m
//  AAKitDemo
//
//  Created by HuangPeng on 7/11/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

#import "RNViewController.h"
#import <RCTRootView.h>
#import "RNBridgeManager.h"

@interface RNViewController ()
@property (nonatomic) BOOL navigationBarWasHidden;
@property (nonatomic, strong) RNNavigationStyle *naviStyle;
@property (nonatomic, strong) RNNavigationContext *context;
@end

@implementation RNViewController

- (instancetype)initWithContext:(RNNavigationContext *)context {
    if (self = [super init]) {
        self.context = context;
        self.naviStyle = context.style;
    }
    return self;
}

- (instancetype)initWithModule:(NSString *)moduleName parameters:(NSDictionary *)parameters {
    RNNavigationContext *context = [RNNavigationContext new];
    context.component = moduleName;
    context.passProps = parameters;
    return [self initWithContext:context];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.context.title) {
        self.title = self.context.title;
    }
    
    RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:[RNBridgeManager sharedManager].bridge
                                                     moduleName:self.context.component
                                              initialProperties:self.context.passProps];
    
    // We want this view to take up the entire screen.
    rootView.frame = self.view.frame;
    rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:rootView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.naviStyle.hideNavigationBar) {
        self.navigationBarWasHidden = self.navigationController.navigationBarHidden;
        [self.navigationController setNavigationBarHidden:YES animated:self.naviStyle.hideNavigationBarAnimated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.naviStyle.hideNavigationBar) {
        if (!self.navigationBarWasHidden) {
            [self.navigationController setNavigationBarHidden:NO animated:self.naviStyle.hideNavigationBarAnimated];
        }
    }
}

- (BOOL)hidesBottomBarWhenPushed
{
    if (!self.naviStyle.hideBottomBarWhenPush) return NO;
    return (self.navigationController.topViewController == self);
}

- (BOOL)prefersStatusBarHidden
{
    if (self.naviStyle.hideStatusBar)
    {
        return YES;
    }
    if (self.naviStyle.hideStatusBarWithNavigationBar)
    {
        return self.navigationController.isNavigationBarHidden;
    }
    else
    {
        return NO;
    }
}

@end
