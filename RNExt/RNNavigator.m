//
//  RNNavigator.m
//  AAKitDemo
//
//  Created by HuangPeng on 7/11/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

#import "RNNavigator.h"
#import "RNViewController.h"
#import <MJExtension.h>

@implementation RNViewControllerFinder

- (UIViewController *)topViewController {
    return [self findTopVC:[[UIApplication sharedApplication].delegate window].rootViewController];
}

- (UIViewController *)findTopVC:(UIViewController *)vc {
    if (vc.presentedViewController) {
        return [self findTopVC:vc.presentedViewController];
    }
    
    if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self findTopVC:[(UITabBarController *)vc selectedViewController]];
    }
    
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self findTopVC:[(UINavigationController *)vc viewControllers].lastObject];
    }
    return vc;
}

- (UITabBarController *)tabBarController {
    UIViewController *vc = [[UIApplication sharedApplication].delegate window].rootViewController;
    if ([vc isKindOfClass:[UITabBarController class]]) {
        return (UITabBarController *)vc;
    }
    return nil;
}

@end

@implementation RNNavigationStyle

@end

@implementation RNNavigationContext

@end
               
@implementation RNNavigator {
    
}

static id<RNViewControllerFinder> navigatorTopViewControllerFinder = nil;

+ (void)setTopViewControllerFinder:(id<RNViewControllerFinder>)topViewControllerFinder {
    navigatorTopViewControllerFinder = topViewControllerFinder;
}

- (id<RNViewControllerFinder>)controllerFinder {
    if (navigatorTopViewControllerFinder == nil) {
        navigatorTopViewControllerFinder = [RNViewControllerFinder new];
    }
    return navigatorTopViewControllerFinder;
}

- (UIViewController *)topVC {
    return [[self controllerFinder] topViewController];
}

- (UITabBarController *)tabBarController {
    return [[self controllerFinder] tabBarController];
}

static id<RNViewControllerFactory> navigatorControllerFactory = nil;
+ (void)setViewControllerFactory:(id<RNViewControllerFactory>)controlerFactory {
    navigatorControllerFactory = controlerFactory;
}

- (UIViewController *)controllerWithContext:(NSDictionary *)context {
    return [self controllerWithContext:context callback:nil];
}

- (UIViewController *)controllerWithContext:(NSDictionary *)context callback:(RCTResponseSenderBlock)callback {
    RNNavigationContext *naviContext = [RNNavigationContext mj_objectWithKeyValues:context];
    naviContext.callback = callback;
    
    if (naviContext.isNativeComponent) {
        NSAssert(navigatorControllerFactory != nil, @"you need to set navigationControllerFactory");
        UIViewController *vc = [navigatorControllerFactory controllerWithContext:naviContext];
        NSAssert(vc != nil, @"failed to create component: %@", naviContext.component);
        return vc;
    }
    else {
        if (naviContext.component) {
            return [[RNViewController alloc] initWithContext:naviContext];
        }
        return nil;
    }
}

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

// This is an exported method that is available in JS.
RCT_EXPORT_METHOD(pop:(BOOL)animated completion:(RCTResponseSenderBlock)completion) {
    [[self topVC].navigationController popViewControllerAnimated:YES];
}

RCT_EXPORT_METHOD(push:(NSDictionary *)context animated:(BOOL)animated callback:(RCTResponseSenderBlock)callback) {
    UIViewController *vc = [self controllerWithContext:context callback:callback];
    if (vc) {
        [[self topVC].navigationController pushViewController:vc animated:animated];
    }
}

RCT_EXPORT_METHOD(dismiss:(BOOL)animated completion:(RCTResponseSenderBlock)completion) {
    [[self topVC] dismissViewControllerAnimated:animated completion:^{
        if (completion) {
            completion(@[]);
        }
    }];
}

RCT_EXPORT_METHOD(present:(NSDictionary *)context animated:(BOOL)animated completion:(RCTResponseSenderBlock)completion callback:(RCTResponseSenderBlock)callback) {
    UIViewController *vc = [self controllerWithContext:context callback:callback];
    if (vc) {
        [[self topVC] presentViewController:vc animated:animated completion:^{
            if (completion) {
                completion(@[]);
            }
        }];
    }
}

RCT_EXPORT_METHOD(popToRoot:(BOOL)animated) {
    [[self topVC].navigationController popToRootViewControllerAnimated:animated];
}

RCT_EXPORT_METHOD(setTop:(NSDictionary *)context animated:(BOOL)animated) {
    UIViewController *vc = [self controllerWithContext:context];
    if (vc) {
        UINavigationController *nav = [self topVC].navigationController;
        NSMutableArray *vcs = [nav.viewControllers mutableCopy];
        if (vcs.count > 0) {
            vcs[vcs.count - 1] = vc;
            [nav setViewControllers:vcs animated:animated];
        }
    }
}

RCT_EXPORT_METHOD(setRoot:(NSDictionary *)context animated:(BOOL)animated) {
    UIViewController *vc = [self controllerWithContext:context];
    if (vc) {
        [[self topVC].navigationController setViewControllers:@[vc] animated:animated];
    }
}

RCT_EXPORT_METHOD(switchToTab:(NSInteger)tabIndex) {
    UITabBarController *tabController = [self tabBarController];
    if (tabIndex >= 0 && tabIndex < tabController.viewControllers.count) {
        if (tabIndex != tabController.selectedIndex) {
            tabController.selectedIndex = tabIndex;
        }
    }
    else {
        NSAssert(NO, @"tabIndex: %zi exceed range: 0-%zi", tabIndex, tabController.viewControllers.count);
    }
}

@end
