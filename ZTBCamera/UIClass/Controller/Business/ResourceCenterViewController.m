//
//  ResourceCenterViewController.m
//  ZTBCamera
//
//  Created by Tibin Zhang on 2017/6/1.
//  Copyright © 2017年 Xueshan Financial Information Service Co., Ltd. All rights reserved.
//

#import "ResourceCenterViewController.h"

#import <HMSegmentedControl/HMSegmentedControl.h>
#import "ZTBSegmentedViewController.h"
#import "BeautifulPhotoFrameViewController.h"
#import "CutePhotoStickerViewController.h"
#import "PhotoEffectsStudioViewController.h"

@interface ResourceCenterViewController () <UIScrollViewDelegate>
{
//    ZTBSegmentedViewController *_segmentedVC;
    BeautifulPhotoFrameViewController *_photoFrameVC;
    CutePhotoStickerViewController *_photoStickerVC;
    PhotoEffectsStudioViewController *_photoEffectVC;
    
}

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, assign)   NSInteger defaultIndex;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@end

@implementation ResourceCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.defaultIndex = 0;
    [self configureNavigationBarView];
    [self configureContentViewController];
}

- (void)configureNavigationBarView
{
    self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"精美相框", @"照片贴纸", @"照片特效"]];
    _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    _segmentedControl.frame = CGRectMake(0, 0, 260, 44);
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.selectionIndicatorColor = [UIColor colorWithHexString:@"f3d45d"];
    _segmentedControl.backgroundColor = [UIColor clearColor];
    _segmentedControl.selectionIndicatorHeight = 4.0f;
    [_segmentedControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:16.0f]}];
        return attString;
    }];
    [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentedControl;
    
    UIButton * leftBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBackButton.frame = CGRectMake(0, 0, 12, 22);
    [leftBackButton addTarget:self action:@selector(leftBackButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftBackButton setBackgroundImage:[UIImage imageNamed:@"common_back"] forState:UIControlStateNormal];
    [leftBackButton setBackgroundImage:[UIImage imageNamed:@"common_back"] forState:UIControlStateHighlighted];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:leftBackButton];
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationItem.backBarButtonItem = nil;
}

- (void)configureContentViewController
{
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    self.contentScrollView.backgroundColor = [UIColor clearColor];
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
    self.contentScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame)*3, CGRectGetHeight(self.contentScrollView.frame)-64);
    [self.view addSubview:self.contentScrollView];
    [self.contentScrollView scrollRectToVisible:CGRectMake(self.view.frame.size.width * self.defaultIndex, 0, self.view.frame.size.width, 200) animated:YES];
    
    _photoFrameVC = [[BeautifulPhotoFrameViewController alloc] init];
    [_photoFrameVC.view setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.contentScrollView.frame))];
    [self.contentScrollView addSubview:_photoFrameVC.view];
    [self addChildViewController:_photoFrameVC];
    
    _photoStickerVC = [[CutePhotoStickerViewController alloc] init];
    [_photoStickerVC.view setFrame:CGRectMake(CGRectGetWidth(self.view.bounds), 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.contentScrollView.frame))];
    [self.contentScrollView addSubview:_photoStickerVC.view];
    [self addChildViewController:_photoStickerVC];
    
   _photoEffectVC = [[PhotoEffectsStudioViewController alloc] init];
    [_photoEffectVC.view setFrame:CGRectMake(CGRectGetWidth(self.view.bounds) * 2, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.contentScrollView.frame))];
    [self.contentScrollView addSubview:_photoEffectVC.view];
    [self addChildViewController:_photoEffectVC];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    NSInteger index = segmentedControl.selectedSegmentIndex;
    [self.contentScrollView scrollRectToVisible:CGRectMake(self.view.frame.size.width * index, 0, self.view.frame.size.width, 200) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
}

#pragma mark - UIScrollViewDelegate - 超出边界不让滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.contentScrollView.contentOffset.x <=0 || self.contentScrollView.contentOffset.x >= self.contentScrollView.frame.size.width) {
        [scrollView setBounces:NO];
    }
    else {
        [scrollView setBounces:YES];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
