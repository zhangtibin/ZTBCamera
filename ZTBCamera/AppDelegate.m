//
//  AppDelegate.m
//  ZTBCamera
//
//  Created by Tibin Zhang on 2017/5/26.
//  Copyright © 2017年 Dreams of Ideal World Co., Ltd. All rights reserved.
//

#import "AppDelegate.h"

#import "CameraMainViewController.h"
#import "ZTBBaseNavigationController.h"
#import "ZTBServicesFactory.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    CameraMainViewController *mainVC = [[CameraMainViewController alloc] init];
    ZTBBaseNavigationController *navNC = [[ZTBBaseNavigationController alloc] initWithRootViewController:mainVC];
    self.window.rootViewController = navNC;
    [self.window makeKeyAndVisible];
    
    ZTBServicesFactory *serviceFactory = [[ZTBServicesFactory alloc] init];
    [serviceFactory.appService registerApplicationUIConfigureWithApplication:application];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark 点击对应Icon的回调,判断对应的Icon
-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
//#warning 3D_Touch的功能只有>=Iphone6s的情况下才能使用(self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)
    
    NSLog(@"得到的点击类型标识是:%@",shortcutItem.type);
    if([shortcutItem.type isEqualToString:@"SearchItem"]){
        ZTBLog(@"点击了搜索");
    }
    else if ([shortcutItem.type isEqualToString:@"PlayItem"]){
        ZTBLog(@"点击了播放");
    }
    else if ([shortcutItem.type isEqualToString:@"EditItem"]){
        ZTBLog(@"点击了编辑 Item");
    }
    else if ([shortcutItem.type isEqualToString:@"PauseItem"]){
        ZTBLog(@"点击了暂停的 Item");
    }
    else if ([shortcutItem.type isEqualToString:@"AddItem"]){
        ZTBLog(@"点击了添加的 Item");
    }
    else if ([shortcutItem.type isEqualToString:@"LocationItem"]){
        ZTBLog(@"点击了定位的 Item");
    }
    else if ([shortcutItem.type isEqualToString:@"ShareItem"]){
        ZTBLog(@"点击了分享的 Item");
    }
    else{
        
    }
}

@end
