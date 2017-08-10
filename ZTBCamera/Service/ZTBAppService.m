//
//  ZTBAppService.m
//  ZTBCamera
//
//  Created by Tibin Zhang on 2017/6/1.
//  Copyright © 2017年 Xueshan Financial Information Service Co., Ltd. All rights reserved.
//

#import "ZTBAppService.h"

@implementation ZTBAppService
IMPLEMENT_SINGLETON(ZTBAppService, sharedZTBAppService);

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)registerThirdSDKConfigure
{
    ZTBLog(@"=== 第三方配置 ===");
}

- (void)registerApplicationUIConfigureWithApplication:(UIApplication *)application
{
    [self initNavigationBarAppearanceWithApplication:application];
}

- (void)initNavigationBarAppearanceWithApplication:(UIApplication *)application
{
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NewNavBar"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBarTintColor:RGB(251, 68, 101)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                           NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
