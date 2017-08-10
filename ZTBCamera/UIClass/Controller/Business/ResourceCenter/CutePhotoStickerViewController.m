//
//  CutePhotoStickerViewController.m
//  ZTBCamera
//
//  Created by Tibin Zhang on 2017/6/1.
//  Copyright © 2017年 Xueshan Financial Information Service Co., Ltd. All rights reserved.
//

#import "CutePhotoStickerViewController.h"

#import "PhotoResourceCell.h"

@interface CutePhotoStickerViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) NSMutableArray *contentArray;

@end

@implementation CutePhotoStickerViewController
- (UICollectionView *)contentCollectionView
{
    if (!_contentCollectionView) {
        UICollectionViewFlowLayout * flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.sectionInset = UIEdgeInsetsZero;
        flowlayout.headerReferenceSize=CGSizeMake(self.view.frame.size.width, 40);
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64) collectionViewLayout:flowlayout];
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.showsVerticalScrollIndicator = NO;
        _contentCollectionView.backgroundColor = [UIColor clearColor];
        UINib *nib = [UINib nibWithNibName:@"PhotoResourceCell" bundle:nil];
        [_contentCollectionView registerNib:nib forCellWithReuseIdentifier:@"IDPhotoResourceCell"];
        [_contentCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"IDSectionHeader"];
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
    
    for (int i = 0; i < 8; i++) {
        UIImage *resourceImage = [UIImage imageNamed:[NSString stringWithFormat:@"processImg%d", i+1]];
        [self.contentArray addObject:resourceImage];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.contentArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView* reusableView = nil;
    if (kind==UICollectionElementKindSectionHeader) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"IDSectionHeader" forIndexPath:indexPath];
        [[reusableView viewWithTag:101] removeFromSuperview];
        
        UIView *SectionHeadView = [[UIView alloc]init];
        SectionHeadView.frame =CGRectMake(0, 0, self.view.frame.size.width, 40);
        [reusableView addSubview:SectionHeadView];
        SectionHeadView.tag = 101;
        reusableView.backgroundColor = [UIColor clearColor];
        
        UILabel * sectionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, SectionHeadView.frame.size.width-40, 20)];
        sectionTitleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        sectionTitleLabel.textColor = [UIColor colorWithHexString:@"f3d45d"];
        sectionTitleLabel.text = @"美妆贴纸";
        [SectionHeadView addSubview:sectionTitleLabel];
        
        return reusableView;
    }
    return reusableView;
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
