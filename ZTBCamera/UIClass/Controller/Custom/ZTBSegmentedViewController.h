//
//  ZTBSegmentedViewController.h
//  ZTBCamera
//
//  Created by Tibin Zhang on 2017/6/1.
//  Copyright © 2017年 Xueshan Financial Information Service Co., Ltd. All rights reserved.
//

#import "ZTBBaseViewController.h"

#import <HMSegmentedControl/HMSegmentedControl.h>

@protocol ZTBSegMentedViewDataSource;
@protocol ZTBSegMentedViewDelegate;

@interface ZTBSegmentedViewController : ZTBBaseViewController <UIScrollViewDelegate>

@property (nonatomic, weak)   id <ZTBSegMentedViewDataSource> dataSource;
@property (nonatomic, weak)   id <ZTBSegMentedViewDelegate>   delegate;

@property (nonatomic, strong)   HMSegmentedControl *segmentedControl;
@property (nonatomic, strong)   NSArray *viewControllers;
@property (nonatomic, strong)   UIViewController *currentViewController;
@property (nonatomic, assign)   CGRect frame;
@property (nonatomic, assign)   NSInteger defaultIndex;

@property (nonatomic, strong) UIScrollView *contentScrollView;

@end

@protocol ZTBSegMentedViewDataSource <NSObject>

@required
- (HMSegmentedControl *)segmentedControlOfSegMentedViewController:(ZTBSegmentedViewController *)segMentedViewController;

- (NSArray *)viewControllersOfSegMentedViewController:(ZTBSegmentedViewController *)segMentedViewController;

@end

@protocol ZTBSegMentedViewDelegate <NSObject>

@optional
-(void)segMentedViewController:(ZTBSegmentedViewController *)segMentedViewController didSelectedIndex:(NSUInteger)index;

-(void)segMentedViewController:(ZTBSegmentedViewController *)segMentedViewController willSelectedIndex:(NSUInteger)index;

@end

