//
//  RNBridgeManager.h
//  AAKitDemo
//
//  Created by HuangPeng on 7/11/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RCTBridge.h>

/**
 *  [[RNBridgeManager sharedManager] setupWithJSHost:@"http://192.168.2.60:8081" LaunchOptions:launchOptions];
 */
@interface RNBridgeManager : NSObject

+ (instancetype)sharedManager;

- (void)setupWithJSHost:(NSString *)host LaunchOptions:(NSDictionary *)launchOptions;

- (void)verifyModules:(NSArray *)modules;

// This method allows us to have access to `NativeModules` that have
// already been instantiated by the bridge.
- (id)nativeModuleForString:(NSString *)moduleName;

/**
 * Here we are exposing a `RCTBridge` publicly so that we can access
 * it from anywhere in our app. We simply need to gain access to the
 * AppDelegate and we can get the `RCTBridge`.
 */
@property (nonatomic, readonly) RCTBridge *bridge;

@end
