//
//  CameraMainViewController.m
//  ZTBCamera
//
//  Created by Tibin Zhang on 2017/5/27.
//  Copyright © 2017年 Dreams of Ideal World Co., Ltd. All rights reserved.
//

#import "CameraMainViewController.h"

#import "CameraItemCell.h"
#import "CameraBeautyViewController.h"
#import "PhotoBeautyViewController.h"
#import "SimplePuzzleViewController.h"
#import "ResourceCenterViewController.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <TZImagePickerController/TZImageManager.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "MagnumOpusViewController.h"
#import "DailyDetailViewController.h"

@interface CameraMainViewController () <UICollectionViewDelegate, UICollectionViewDataSource, TZImagePickerControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *mainBgImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *itemCollectionView;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation CameraMainViewController

- (UIScrollView *)contentScrollView
{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
        [_contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _contentScrollView;
}

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    }
    return _containerView;
}

- (UIImageView *)mainBgImageView
{
    if (!_mainBgImageView) {
        _mainBgImageView = [[UIImageView alloc] init];
        _mainBgImageView.image = [UIImage imageNamed:@"main_page_bg"];
        _mainBgImageView.userInteractionEnabled = YES;
    }
    return _mainBgImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"小希美颜相机";
        _titleLabel.font = [UIFont systemFontOfSize:28.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UICollectionView *)itemCollectionView
{
    if (!_itemCollectionView) {
        UICollectionViewFlowLayout * flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.sectionInset = UIEdgeInsetsZero;
        flowlayout.minimumLineSpacing = 40;
        flowlayout.minimumInteritemSpacing = 0;
        _itemCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake((kScreenWidth - 240)/2, 120, 240, self.view.frame.size.height - 230) collectionViewLayout:flowlayout];
        _itemCollectionView.delegate = self;
        _itemCollectionView.dataSource = self;
        _itemCollectionView.alwaysBounceHorizontal = YES;
        _itemCollectionView.scrollEnabled = NO;
        _itemCollectionView.backgroundColor = [UIColor clearColor];
        UINib *nib = [UINib nibWithNibName:@"CameraItemCell" bundle:nil];
        [_itemCollectionView registerNib:nib forCellWithReuseIdentifier:@"IDCameraItemCell"];
    }
    return _itemCollectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.imageArray = @[@"main_camera", @"main_photo_edit", @"main_beauty_puzzle", @"main_art_puzzle", @"main_resource_download", @"main_special_effects"];
    self.titleArray = @[@"美美相机", @"美化图片", @"简单拼图", @"艺术拼图", @"素材中心", @"特效美化"];
    [self configureUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)configureUI
{
    [self.view addSubview:self.contentScrollView];
    [_contentScrollView addSubview:self.containerView];
    [_containerView addSubview:self.mainBgImageView];
    [_containerView addSubview:self.titleLabel];
    [_containerView addSubview:self.itemCollectionView];
    [self updateContainers];
}

- (void)updateContainers
{
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_contentScrollView);
        make.width.equalTo(_contentScrollView);
    }];
    [_mainBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_containerView.mas_top).offset(30);
        make.centerX.equalTo(_containerView);
        make.height.equalTo(@30);
    }];
    [_itemCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_containerView.mas_left).offset((kScreenWidth - 240)/2);
        make.top.equalTo(_containerView.mas_top).offset(120);
        make.right.equalTo(_containerView.mas_right).offset(-(kScreenWidth - 240)/2);
        make.bottom.height.equalTo(@(self.view.frame.size.height - 230));
    }];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_itemCollectionView.mas_bottom);
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize cellSize = CGSizeMake(100, 120);
    return cellSize;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CameraItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IDCameraItemCell" forIndexPath:indexPath];
    [cell buildCellWithItemImage:[_imageArray objectAtIndex:indexPath.row] title:[_titleArray objectAtIndex:indexPath.row]];;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"当前选中了：%ld", (long)indexPath.row);

    switch (indexPath.row) {
        case 0://美颜相机
        {
            CameraBeautyViewController *VC = [[CameraBeautyViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
            
        case 1://照片美化
        {
//            PhotoBeautyViewController *VC = [[PhotoBeautyViewController alloc] init];
//            [self.navigationController pushViewController:VC animated:YES];
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
            imagePickerVc.isSelectOriginalPhoto = YES;

            imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
            
            // 2. Set the appearance
            // 2. 在这里设置imagePickerVc的外观
            // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
            // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
            // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
             imagePickerVc.navigationBar.translucent = YES;
            
            // 3. Set allow picking video & photo & originalPhoto or not
            // 3. 设置是否可以选择视频/图片/原图
            imagePickerVc.allowPickingVideo = NO;
            imagePickerVc.allowPickingImage = YES;
            imagePickerVc.allowPickingOriginalPhoto = YES;
            imagePickerVc.allowPickingGif = YES;
            
            // 4. 照片排列按修改时间升序
            imagePickerVc.sortAscendingByModificationDate = YES;
            
            // imagePickerVc.minImagesCount = 3;
            // imagePickerVc.alwaysEnableDoneBtn = YES;
            
            // imagePickerVc.minPhotoWidthSelectable = 3000;
            // imagePickerVc.minPhotoHeightSelectable = 2000;
            
            /// 5. Single selection mode, valid when maxImagesCount = 1
            /// 5. 单选模式,maxImagesCount为1时才生效
            imagePickerVc.showSelectBtn = NO;
            imagePickerVc.allowCrop = NO;
            imagePickerVc.needCircleCrop = NO;
            imagePickerVc.circleCropRadius = 100;
            /*
             [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
             cropView.layer.borderColor = [UIColor redColor].CGColor;
             cropView.layer.borderWidth = 2.0;
             }];*/
            
            //imagePickerVc.allowPreview = NO;
#pragma mark - 到这里为止
            
            // You can get the photos by block, the same as by delegate.
            // 你可以通过block或者代理，来得到用户选择的照片.
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                
            }];
            
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
            break;
            
        case 2://简单拼图
        {
            MagnumOpusViewController *VC = [[MagnumOpusViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
            
        case 3://艺术拼图
        {
            DailyDetailViewController *VC = [[DailyDetailViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
            
        case 4://素材中心
        {
            ResourceCenterViewController *VC = [[ResourceCenterViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
            
        case 5://特效美化
        {
            CameraBeautyViewController *VC = [[CameraBeautyViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
            
            
        default:
            break;
    }
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
    
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                ZTBLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
//                        if (self.allowCropSwitch.isOn) { // 允许裁剪,去裁剪
//                            TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
////                                [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
//                            }];
//                            imagePicker.needCircleCrop = self.needCircleCropSwitch.isOn;
//                            imagePicker.circleCropRadius = 100;
//                            [self presentViewController:imagePicker animated:YES completion:nil];
//                        } else {
//                            [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
//                        }
                    }];
                }];
            }
        }];
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
