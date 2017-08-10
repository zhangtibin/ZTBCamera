//
//  ZTBAppService.h
//  ZTBCamera
//
//  Created by Tibin Zhang on 2017/6/1.
//  Copyright © 2017年 Dreams of Ideal World Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZTBAppService <NSObject>

- (void)registerThirdSDKConfigure;
- (void)registerApplicationUIConfigureWithApplication:(UIApplication *)application;

@end

@interface ZTBAppService : NSObject <ZTBAppService>
DECLARE_SINGLETON(ZTBAppService, sharedZTBAppService)

@end
