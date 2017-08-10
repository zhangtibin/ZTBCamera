//
//  ZTBServicesFactory.h
//  ZTBCamera
//
//  Created by Tibin Zhang on 2017/6/1.
//  Copyright © 2017年 Dreams of Ideal World Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZTBAppService.h"

@protocol ZTBServicesFactory <NSObject>

@property (nonatomic, strong, readonly) id <ZTBAppService> appService;

@end

/**
 Class 描述：服务工厂
 */
@interface ZTBServicesFactory : NSObject <ZTBServicesFactory>
DECLARE_SINGLETON(ZTBServicesFactory, sharedZTBServicesFactory);

@end
