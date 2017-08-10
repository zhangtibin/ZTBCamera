//
//  BeautifulPhotoFrameViewController.m
//  ZTBCamera
//
//  Created by Tibin Zhang on 2017/6/1.
//  Copyright © 2017年 Xueshan Financial Information Service Co., Ltd. All rights reserved.
//

#import "BeautifulPhotoFrameViewController.h"

#import "PhotoResourceCell.h"

@interface BeautifulPhotoFrameViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) NSMutableArray *contentArray;

@end

@implementation BeautifulPhotoFrameViewController

- (UICollectionView *)contentCollectionView
{
    if (!_contentCollectionView) {
        UICollectionViewFlowLayout * flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.sectionInset = UIEdgeInsetsZero;
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64) collectionViewLayout:flowlayout];
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.showsVerticalScrollIndicator = NO;
        _contentCollectionView.backgroundColor = [UIColor clearColor];
        UINib *nib = [UINib nibWithNibName:@"PhotoResourceCell" bundle:nil];
        [_contentCollectionView registerNib:nib forCellWithReuseIdentifier:@"IDPhotoResourceCell"];
    }
    return _contentCollectionView;
}

- (NSMutableArray *)contentArray
{
    if (!_contentArray) {
        _contentArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _contentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.contentCollectionView];
    
    for (int i = 0; i < 51; i++) {
        UIImage *resourceImage = [UIImage imageNamed:[NSString stringWithFormat:@"NewbgBtn0%d", i+1]];
        [self.contentArray addObject:resourceImage];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.contentArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize cellSize = CGSizeMake((kScreenWidth - 60)/3, (kScreenWidth - 60)/3);
    return cellSize;
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoResourceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IDPhotoResourceCell" forIndexPath:indexPath];
    
    [cell buildCellWithItem:[_contentArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"当前选中了：%ld", (long)indexPath.row);
    
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
