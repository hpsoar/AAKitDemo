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
@property (nonatomic, copy) NSString *moduleName;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic) BOOL hideNavigationBar;
@property (nonatomic) BOOL navigationBarWasHidden;
@end

@implementation RNViewController

- (instancetype)initWithModule:(NSString *)moduleName parameters:(NSDictionary *)parameters {
    if (self = [super init]) {
        self.moduleName = moduleName;
        self.parameters = parameters;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:[RNBridgeManager sharedManager].bridge
                                                     moduleName:self.moduleName
                                              initialProperties:self.parameters];
    
    // We want this view to take up the entire screen.
    rootView.frame = self.view.frame;
    rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:rootView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.hideNavigationBar) {
        self.navigationBarWasHidden = self.navigationController.navigationBarHidden;
        [self.navigationController setNavigationBarHidden:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.hideNavigationBar) {
        if (!self.navigationBarWasHidden) {
            [self.navigationController setNavigationBarHidden:NO];
        }
    }
}

@end
