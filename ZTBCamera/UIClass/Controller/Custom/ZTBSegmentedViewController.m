//
//  ZTBSegmentedViewController.m
//  ZTBCamera
//
//  Created by Tibin Zhang on 2017/6/1.
//  Copyright © 2017年 Xueshan Financial Information Service Co., Ltd. All rights reserved.
//

#import "ZTBSegmentedViewController.h"

@interface ZTBSegmentedViewController ()

@end

@implementation ZTBSegmentedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)initView {
    self.view.frame = self.frame;
    if ([self.dataSource respondsToSelector:@selector(segmentedControlOfSegMentedViewController:)]) {
        self.segmentedControl = [self.dataSource segmentedControlOfSegMentedViewController:self];
        [self.segmentedControl setFrame:CGRectMake(CGRectGetWidth(self.view.bounds)/2 - CGRectGetWidth(self.segmentedControl.frame)/2, 0, CGRectGetWidth(self.segmentedControl.frame), CGRectGetHeight(self.segmentedControl.frame))];
        [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        self.segmentedControl.selectedSegmentIndex = self.defaultIndex;
        [self.view addSubview:self.segmentedControl];
    }
    
    if ([self.dataSource respondsToSelector:@selector(viewControllersOfSegMentedViewController:)]) {
        self.viewControllers = [self.dataSource viewControllersOfSegMentedViewController:self];
        self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(self.segmentedControl.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.segmentedControl.frame))];
        self.contentScrollView.backgroundColor = [UIColor clearColor];
        self.contentScrollView.pagingEnabled = YES;
        self.contentScrollView.showsHorizontalScrollIndicator = NO;
        self.contentScrollView.delegate = self;
        self.contentScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame)*self.viewControllers.count, CGRectGetHeight(self.contentScrollView.frame));
        [self.view addSubview:self.contentScrollView];
        for (int i = 0;i < self.viewControllers.count;i++) {
            UIViewController *viewController = (UIViewController *)self.viewControllers[i];
            [viewController.view setFrame:CGRectMake(CGRectGetWidth(self.view.bounds)*i, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.contentScrollView.frame))];
            [self.contentScrollView addSubview:viewController.view];
            [self addChildViewController:viewController];
        }
        [self.contentScrollView scrollRectToVisible:CGRectMake(self.view.frame.size.width * self.defaultIndex, 0, self.view.frame.size.width, 200) animated:YES];
    }
    if ([self.delegate respondsToSelector:@selector(segMentedViewController:didSelectedIndex:)]) {
        [self.delegate segMentedViewController:self didSelectedIndex:self.defaultIndex];
    }
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSInteger index = segmentedControl.selectedSegmentIndex;
    [self.contentScrollView scrollRectToVisible:CGRectMake(self.view.frame.size.width * index, 0, self.view.frame.size.width, 200) animated:YES];
    if ([self.delegate respondsToSelector:@selector(segMentedViewController:didSelectedIndex:)]) {
        [self.delegate segMentedViewController:self didSelectedIndex:index];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
    if ([self.delegate respondsToSelector:@selector(segMentedViewController:didSelectedIndex:)]) {
        [self.delegate segMentedViewController:self didSelectedIndex:page];
    }
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
    if ([self.delegate respondsToSelector:@selector(segMentedViewController:willSelectedIndex:)]) {
        [self.delegate segMentedViewController:self willSelectedIndex:0];
    }
}

- (void)setDefaultIndex:(NSInteger)defaultIndex
{
    _defaultIndex = defaultIndex;
    self.segmentedControl.selectedSegmentIndex = defaultIndex;
    if (self.segmentedControl) {
        [self segmentedControlChangedValue:self.segmentedControl];
    }
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
