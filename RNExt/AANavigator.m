//
//  AANavigator.m
//  AAKitDemo
//
//  Created by HuangPeng on 7/11/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

#import "AANavigator.h"
#import "RNViewController.h"

@implementation AATopViewControllerFinder

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

@end

NSString const *AANavigatorContextControllerTypeKey = @"navigator_context_controller_type";
NSString const *AANavigatorContextControllerTypeRN = @"navigator_context_controller_type_rn";
NSString const *AANavigatorContextRNModuleNameKey = @"navigator_context_module_name_key";
NSString const *AANavigatorContextRNModuleParameterKey = @"navigator_context_module_parameter_key";
               
@implementation AANavigator {
    
}

static id<AATopViewControllerFinder> navigatorTopViewControllerFinder = nil;

+ (void)setTopViewControllerFinder:(id<AATopViewControllerFinder>)topViewControllerFinder {
    navigatorTopViewControllerFinder = topViewControllerFinder;
}

- (UIViewController *)topVC {
    if (navigatorTopViewControllerFinder == nil) {
        navigatorTopViewControllerFinder = [AATopViewControllerFinder new];
    }
    return [navigatorTopViewControllerFinder topViewController];
}

static id<AANavigatorViewControllerFactory> navigatorControllerFactory = nil;
+ (void)setViewControllerFactory:(id<AANavigatorViewControllerFactory>)controlerFactory {
    navigatorControllerFactory = controlerFactory;
}

- (UIViewController *)controllerWithContext:(NSDictionary *)context {
    if (navigatorControllerFactory) {
        UIViewController *vc = [navigatorControllerFactory controllerWithContext:context];
        if (vc) {
            return vc;
        }
    }
    
    NSString *controllerType = context[AANavigatorContextControllerTypeKey];
    
    if ([controllerType isEqualToString:AANavigatorContextControllerTypeRN]) {
        NSString *moduleName = context[AANavigatorContextRNModuleNameKey];
        NSDictionary *parameters = context[AANavigatorContextRNModuleParameterKey];
        if (moduleName) {
            return [[RNViewController alloc] initWithModule:moduleName parameters:parameters];
        }
    }
    return nil;
}

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

// This is an exported method that is available in JS.
RCT_EXPORT_METHOD(popController:(NSDictionary *)context animated:(BOOL)animated completion:(RCTResponseSenderBlock)completion) {
    [[self topVC].navigationController popViewControllerAnimated:YES];
}

RCT_EXPORT_METHOD(pushController:(NSDictionary *)context animated:(BOOL)animated) {
    UIViewController *vc = [self controllerWithContext:context];
    if (vc) {
        [[self topVC].navigationController pushViewController:vc animated:animated];
    }
}

RCT_EXPORT_METHOD(dismissController:(NSDictionary *)context animated:(BOOL)animated completion:(RCTResponseSenderBlock)completion) {
    [[self topVC] dismissViewControllerAnimated:animated completion:^{
        if (completion) {
            completion(@[]);
        }
    }];
}

RCT_EXPORT_METHOD(presentController:(NSDictionary *)context animated:(BOOL)animated) {
    UIViewController *vc = [self controllerWithContext:context];
    if (vc) {
        [[self topVC] presentViewController:vc animated:animated completion:^{
        
        }];
    }
}

@end
