//
//  ZTBServicesFactory.m
//  ZTBCamera
//
//  Created by Tibin Zhang on 2017/6/1.
//  Copyright © 2017年 Dreams of Ideal World Co., Ltd. All rights reserved.
//

#import "ZTBServicesFactory.h"

#import "ZTBAppService.h"

@interface ZTBServicesFactory ()

@property (nonatomic, strong, readwrite) id <ZTBAppService> appService;

@end

@implementation ZTBServicesFactory
IMPLEMENT_SINGLETON(ZTBServicesFactory, sharedZTBServicesFactory);

- (id<ZTBAppService>)appService
{
    if (!_appService) {
        _appService = [[ZTBAppService alloc] init];
    }
    return _appService;
}

@end
