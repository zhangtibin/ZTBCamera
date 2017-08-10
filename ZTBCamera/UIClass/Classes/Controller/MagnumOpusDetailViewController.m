//
//  MagnumOpusDetailViewController.m
//  ZTBCamera
//
//  Created by Tibin Zhang on 2017/6/13.
//  Copyright © 2017年 Xueshan Financial Information Service Co., Ltd. All rights reserved.
//

#import "MagnumOpusDetailViewController.h"

#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import "ZTBBaseNavigationController.h"
#import <MWPhotoBrowser/MWPhoto.h>

@interface MagnumOpusDetailViewController () <MWPhotoBrowserDelegate>

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation MagnumOpusDetailViewController

- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _imageArray;
}

- (UIScrollView *)contentScrollView
{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
        [self.view addSubview:_contentScrollView];
        [_contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        _containerView = [[UIView alloc] init];
        [_contentScrollView addSubview:_containerView];
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_contentScrollView);
            make.width.equalTo(_contentScrollView);
        }];
        
        UIImageView *userAvatar = [[UIImageView alloc] init];
        userAvatar.image = [UIImage imageNamed:@"0.jpg"];
        [_containerView addSubview:userAvatar];
        [userAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_containerView.mas_left).offset(15);
            make.top.equalTo(_containerView.mas_top).offset(15);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
        
        UILabel *userNickLabel = [[UILabel alloc] init];
        userNickLabel.text = @"**** 先生";
        userNickLabel.textColor = [UIColor colorWithHexString:@"232323"];
        userNickLabel.font = [UIFont systemFontOfSize:14.0];
        [_containerView addSubview:userNickLabel];
        [userNickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(userAvatar.mas_top);
            make.left.equalTo(userAvatar.mas_right).offset(11);
            make.height.equalTo(@16);
        }];
        
        UILabel *msgLabel = [[UILabel alloc] init];
        msgLabel.font = [UIFont systemFontOfSize:14.0];
        msgLabel.numberOfLines = 0;
        [msgLabel sizeToFit];
        msgLabel.textColor = [UIColor colorWithHexString:@"8b8b8b"];
        msgLabel.backgroundColor = [UIColor clearColor];
        if (!EMPTY_STRING(@"sds")) {
            msgLabel.text = @"四季豆吉萨瑟吉欧if酒叟打暑假工囧就是个 所见到过我哦啊色哦if啊额为哦使劲地奥摩瑟吉欧IDJS傲娇使劲地欧式及哦啊几位送傲娇噶凭空抹噶的囧撒骄傲机四季豆吉萨";
        }
        else {
            msgLabel.text = @"";
        }
        [_containerView addSubview:msgLabel];
        [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(userAvatar.mas_bottom).offset(10);
            make.left.equalTo(_containerView.mas_left).offset(15);
            make.right.equalTo(_containerView.mas_right).with.offset(-15);
            make.height.equalTo(@([self contentSize:msgLabel.text].height));
        }];
        
        CGFloat originY = 0;
        for (int i = 0; i < 8; i++) {
            UIImageView * photoImage = [[UIImageView alloc] init];
            photoImage.userInteractionEnabled = YES;
//            [photoImage sd_setImageWithURL:[NSURL URLWithString:[_urlArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"common_placeholder_banner"]];
            photoImage.tag = 100+i;
            photoImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
            [_containerView addSubview:photoImage];
            [photoImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_containerView.mas_left).offset(15);
                make.right.equalTo(_containerView.mas_right).offset(-15);
                make.top.equalTo(msgLabel.mas_bottom).offset(10+originY);
                make.size.mas_offset(CGSizeMake(kScreenWidth, kScreenWidth*(photoImage.image.size.height*1.0/photoImage.image.size.width)));
            }];
            originY = originY + kScreenWidth*(photoImage.image.size.height*1.0/photoImage.image.size.width)+10;
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reviewPhoto:)];
            [photoImage addGestureRecognizer:tapGesture];
        }

        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(msgLabel.mas_bottom).offset(originY + 20);
        }];
    }
    return _contentScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"日常";
    for (int i = 0; i < 8; i++) {
        [self.imageArray addObject:[MWPhoto photoWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i]]]];
    }
    self.contentScrollView.backgroundColor  =[UIColor whiteColor];
    
}

- (void)reviewPhoto:(UITapGestureRecognizer *)tapGesture
{
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = YES;
    [browser setCurrentPhotoIndex:tapGesture.view.tag - 100];
//    [self presentViewController:browser animated:YES completion:nil];
    ZTBBaseNavigationController *nav = [[ZTBBaseNavigationController alloc] initWithRootViewController:browser];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (CGSize)contentSize:(NSString*)content {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    UIFont *fontContent = [UIFont systemFontOfSize:14.0];
    NSDictionary *dic = @{NSFontAttributeName : fontContent, NSParagraphStyleAttributeName : style};
    CGSize size = [content boundingRectWithSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil].size;
    return size;
}

#pragma mark ######## MWPhotoBrowser delegate methods ########
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _imageArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _imageArray.count)
        return [_imageArray objectAtIndex:index];
    return nil;
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
