//
//  AANavigator.h
//  AAKitDemo
//
//  Created by HuangPeng on 7/11/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RCTBridgeModule.h>

@protocol AATopViewControllerFinder <NSObject>

- (UIViewController *)topViewController;

@end

@interface AATopViewControllerFinder : NSObject <AATopViewControllerFinder>

@end

@protocol AANavigatorViewControllerFactory <NSObject>

- (UIViewController *)controllerWithContext:(NSDictionary *)context;

@end

extern NSString const *AANavigatorContextControllerTypeKey;
extern NSString const *AANavigatorContextControllerTypeRN;
extern NSString const *AANavigatorContextRNModuleNameKey;
extern NSString const *AANavigatorContextRNModuleParameterKey;
                
@interface AANavigator : NSObject <RCTBridgeModule>

/**
 *  the way to get top controller,
 *  default: find from
 *
 *  @param topControllerBlock t
 */
+ (void)setTopViewControllerFinder:(id<AATopViewControllerFinder>)topViewControllerFinder;

+ (void)setViewControllerFactory:(id<AANavigatorViewControllerFactory>)controlerFactory;

- (void)popController:(NSDictionary *)context animated:(BOOL)animated completion:(RCTResponseSenderBlock)completion;

- (void)pushController:(NSDictionary *)context animated:(BOOL)animated;

- (void)dismissController:(NSDictionary *)context animated:(BOOL)animated completion:(RCTResponseSenderBlock)completion;

- (void)presentController:(NSDictionary *)context animated:(BOOL)animated;

@end
