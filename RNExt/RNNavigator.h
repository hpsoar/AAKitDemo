//
//  RNNavigator.h
//  AAKitDemo
//
//  Created by HuangPeng on 7/11/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RCTBridgeModule.h>

@interface RNNavigationStyle : NSObject

@property (nonatomic) BOOL hideNavigationBar;
@property (nonatomic) BOOL hideNavigationBarAnimated;
@property (nonatomic) BOOL hideBottomBarWhenPush;
@property (nonatomic) BOOL hideStatusBar;
@property (nonatomic) BOOL hideStatusBarWithNavigationBar;

@end

@interface RNNavigationContext : NSObject

@property (nonatomic) BOOL isNativeComponent; // default NO;
@property (nonatomic, copy) NSString *component;
@property (nonatomic, copy) NSDictionary *passProps;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *backButtonTitle;

@property (nonatomic, strong) RNNavigationStyle *style;

@property (nonatomic, copy) RCTResponseSenderBlock callback;

@end

@protocol RNViewControllerFinder <NSObject>

- (UIViewController *)topViewController;
- (UITabBarController *)tabBarController;

@end

@interface RNViewControllerFinder : NSObject <RNViewControllerFinder>

@end

@protocol RNViewControllerFactory <NSObject>

- (UIViewController *)controllerWithContext:(RNNavigationContext *)context;

@end
                
@interface RNNavigator : NSObject <RCTBridgeModule>

/**
 *  the way to get top controller,
 *  default: find from
 *
 *  @param topControllerBlock t
 */
+ (void)setTopViewControllerFinder:(id<RNViewControllerFinder>)topViewControllerFinder;

+ (void)setViewControllerFactory:(id<RNViewControllerFactory>)controlerFactory;

@end
