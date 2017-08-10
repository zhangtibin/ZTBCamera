//
//  DailyDetailViewController.m
//  ZTBCamera
//
//  Created by Tibin Zhang on 2017/6/13.
//  Copyright © 2017年 Dreams of Ideal World Co., Ltd. All rights reserved.
//

#import "DailyDetailViewController.h"

@interface DailyDetailViewController ()

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation DailyDetailViewController

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        [self.view addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.equalTo(@50);
        }];
        
        UIView *sepView = [[UIView alloc] init];
        sepView.backgroundColor = [UIColor colorWithHexString:@"d9d9d9"];
        [_bottomView addSubview:sepView];
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_bottomView);
            make.height.equalTo(@.5);
        }];
        
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"viedo_icon_fretransmission_nor"] forState:UIControlStateNormal];
        [_bottomView addSubview:shareBtn];
        [shareBtn addTarget:self action:@selector(shareButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_bottomView.mas_right).offset(-15);
            make.centerY.equalTo(_bottomView);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        UIButton *collectingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [collectingBtn setBackgroundImage:[UIImage imageNamed:@"viedo_icon_colection_nor"] forState:UIControlStateNormal];
        [_bottomView addSubview:collectingBtn];
        [collectingBtn addTarget:self action:@selector(collectingBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [collectingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(shareBtn.mas_left).offset(-18);
            make.centerY.equalTo(_bottomView);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        UILabel *praiseCountLabel = [[UILabel alloc] init];
        praiseCountLabel.textColor = [UIColor colorWithHexString:@"999999"];
        praiseCountLabel.text = @"28328";
        praiseCountLabel.font = [UIFont systemFontOfSize:12.0];
        [_bottomView addSubview:praiseCountLabel];
        [praiseCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(collectingBtn.mas_left).offset(-18);
            make.centerY.equalTo(_bottomView);
            make.height.equalTo(@15);
        }];
        
        UIButton *praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [praiseBtn setBackgroundImage:[UIImage imageNamed:@"viedo_icon_like_nor"] forState:UIControlStateNormal];
        [_bottomView addSubview:praiseBtn];
        [praiseBtn addTarget:self action:@selector(praiseBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(praiseCountLabel.mas_left);
            make.centerY.equalTo(_bottomView);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    return _bottomView;
}

- (UIScrollView *)contentScrollView
{
    CGFloat cellHeight = 0;
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
        [self.view addSubview:_contentScrollView];
        [_contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(-50);
        }];
        
        _containerView = [[UIView alloc] init];
        [_contentScrollView addSubview:_containerView];
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_contentScrollView);
            make.width.equalTo(_contentScrollView);
        }];
        
        UILabel *msgLabel = [[UILabel alloc] init];
        msgLabel.font = [UIFont systemFontOfSize:14.0];
        msgLabel.numberOfLines = 0;
        [msgLabel sizeToFit];
        msgLabel.textColor = [UIColor colorWithHexString:@"8b8b8b"];
        if (!EMPTY_STRING(@"sds")) {
            msgLabel.text = @"四季豆吉萨瑟吉欧if酒叟打暑假工囧就是个 所见到过我哦啊色哦if啊额为哦使劲地奥摩瑟吉欧IDJS傲娇使劲地欧式及";
        }
        else {
            msgLabel.text = @"";
        }
        [_containerView addSubview:msgLabel];
        [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_containerView.mas_top).offset(10);
            make.left.equalTo(_containerView.mas_left).offset(15);
            make.right.equalTo(_containerView.mas_right).with.offset(-15);
            make.height.equalTo(@([self contentSize:msgLabel.text].height));
        }];
        cellHeight += [self contentSize:msgLabel.text].height;
        
        UIView *itemBgView = [[UIView alloc] init];
        [_containerView addSubview:itemBgView];
        int iamgeCount = 7;
        for (int i= 0; i < iamgeCount; i++) {
            UIImageView *imageV = [[UIImageView alloc] init];
            imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i]];
            [itemBgView addSubview:imageV];
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(itemBgView.mas_top).offset(i/3 * ((kScreenWidth - 46)/3 + 8));
                make.left.equalTo(itemBgView.mas_left).offset(15+i%3*((kScreenWidth - 46)/3+8));
                make.size.mas_equalTo(CGSizeMake((kScreenWidth - 46)/3.0, (kScreenWidth - 46)/3.0));
            }];
        }
        int itemViewHeight = 0;
        if (iamgeCount <= 3) {
            itemViewHeight = (kScreenWidth - 46)/3 + 8 - 8;
        }
        else if (iamgeCount >3 && iamgeCount <=6) {
            itemViewHeight = 2* ((kScreenWidth - 46)/3 + 8) - 8;
        }
        else if (iamgeCount > 6) {
            itemViewHeight = 3* ((kScreenWidth - 46)/3 + 8) - 8;
        }
        [itemBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(msgLabel.mas_bottom).offset(8);
            make.left.right.equalTo(_containerView);
            make.height.equalTo(@(itemViewHeight));
        }];
        cellHeight += itemViewHeight;
        
        UIImageView *userAvatar = [[UIImageView alloc] init];
        userAvatar.image = [UIImage imageNamed:@"0.jpg"];
        userAvatar.layer.cornerRadius = 17.5;
        userAvatar.layer.masksToBounds = YES;
        [_containerView addSubview:userAvatar];
        [userAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_containerView.mas_left).offset(15);
            make.top.equalTo(itemBgView.mas_bottom).offset(17);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
        
        UILabel *userNickLabel = [[UILabel alloc] init];
        userNickLabel.text = @"**** 先生";
        userNickLabel.textColor = [UIColor colorWithHexString:@"232323"];
        userNickLabel.font = [UIFont systemFontOfSize:14.0];
        [_containerView addSubview:userNickLabel];
        [userNickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(userAvatar);
            make.left.equalTo(userAvatar.mas_right).offset(11);
            make.height.equalTo(@16);
        }];
        
        UIButton *concernBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [concernBtn setTitle:@"关注" forState:UIControlStateNormal];
        concernBtn.layer.masksToBounds = YES;
        concernBtn.layer.cornerRadius = 3.0;
        [concernBtn setBackgroundColor:[UIColor redColor]];
        [concernBtn addTarget:self action:@selector(concernButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:concernBtn];
        [concernBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(userAvatar);
            make.right.equalTo(_containerView.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(65, 30));
        }];
        
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(userAvatar.mas_bottom).offset(20);
        }];
        
    }
    return _contentScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentScrollView.backgroundColor = [UIColor whiteColor];
    self.bottomView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 关注
- (void)concernButtonDidClick:(id)sender
{
    
}

#pragma mark - 赞
- (void)praiseBtnDidClick:(id)sender
{
    
}

#pragma mark - 收藏
- (void)collectingBtnDidClick:(id)sender
{
    
}

#pragma mark - 分享
- (void)shareButtonDidClick:(id)sender
{
    
}

- (CGSize)contentSize:(NSString*)content {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    UIFont *fontContent = [UIFont systemFontOfSize:14.0];
    NSDictionary *dic = @{NSFontAttributeName : fontContent, NSParagraphStyleAttributeName : style};
    CGSize size = [content boundingRectWithSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil].size;
    return size;
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
