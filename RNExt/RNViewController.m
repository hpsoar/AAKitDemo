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
@property (nonatomic, strong) RCTRootView *rootView;
@end

@implementation RNViewController

- (instancetype)initWithContext:(RNNavigationContext *)context bridge:(RCTBridge *)bridge {
    if (self = [super init]) {
        self.context = context;
        self.naviStyle = context.style;
        
        self.rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                 moduleName:self.context.component
                                          initialProperties:self.context.passProps];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.context.title) {
        self.title = self.context.title;
    }
    
    // We want this view to take up the entire screen.
    self.rootView.frame = self.view.frame;
    self.rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:self.rootView];
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
