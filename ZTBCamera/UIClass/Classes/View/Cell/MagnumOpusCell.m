//
//  MagnumOpusCell.m
//  ZTBCamera
//
//  Created by Tibin Zhang on 2017/6/7.
//  Copyright © 2017年 Dreams of Ideal World Co., Ltd. All rights reserved.
//

#import "MagnumOpusCell.h"

#import "SpacingLabel.h"

@implementation MagnumOpusCell
{
    UIView *contentBgView;
    CGFloat cellHeight;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)buildCellWithItem:(id)item
{
    cellHeight = 0;
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    for (UIView *view in [contentBgView subviews]) {
        [view removeFromSuperview];
    }
    contentBgView = [[UIView alloc] init];
    contentBgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:contentBgView];
    [contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.right.bottom.equalTo(self.contentView);
    }];
    cellHeight += 10;
    
    UIImageView *userAvatar = [[UIImageView alloc] init];
    userAvatar.image = [UIImage imageNamed:@"0.jpg"];
    [contentBgView addSubview:userAvatar];
    [userAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentBgView.mas_left).offset(15);
        make.top.equalTo(contentBgView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    cellHeight += 15;
    cellHeight += 35;
    UILabel *userNickLabel = [[UILabel alloc] init];
    userNickLabel.text = @"**** 先生";
    userNickLabel.textColor = [UIColor colorWithHexString:@"232323"];
    userNickLabel.font = [UIFont systemFontOfSize:14.0];
    [contentBgView addSubview:userNickLabel];
    [userNickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userAvatar.mas_top);
        make.left.equalTo(userAvatar.mas_right).offset(11);
        make.height.equalTo(@16);
    }];
    
    cellHeight += 10;
    
    UILabel *msgLabel = [[UILabel alloc] init];
    msgLabel.font = [UIFont systemFontOfSize:14.0];
    msgLabel.numberOfLines = 0;
    [msgLabel sizeToFit];
    msgLabel.textColor = [UIColor colorWithHexString:@"8b8b8b"];
    if (!EMPTY_STRING(@"sds")) {
        msgLabel.text = @"四季豆吉萨瑟吉欧if酒叟打暑假工囧就是个 所见到过我哦啊色哦if啊额为哦使劲地奥摩瑟吉欧IDJS傲娇使劲地欧式及哦啊几位送傲娇噶凭空抹噶的囧撒骄傲机四季豆吉萨";
    }
    else {
        msgLabel.text = @"";
    }
    [contentBgView addSubview:msgLabel];
    [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userAvatar.mas_bottom).offset(10);
        make.left.equalTo(contentBgView.mas_left).offset(60);
        make.right.equalTo(contentBgView.mas_right).with.offset(-15);
        make.height.equalTo(@([self contentSize:msgLabel.text].height));
    }];
    cellHeight += [self contentSize:msgLabel.text].height;
    
    UIView *itemBgView = [[UIView alloc] init];
    [contentBgView addSubview:itemBgView];
    
    BOOL isVideo = NO;
    if (isVideo) {
        
        UIImageView *coverImage = [[UIImageView alloc] init];
        coverImage.image = [UIImage imageNamed:@"1.jpg"];
        [itemBgView addSubview:coverImage];
        [coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(itemBgView);
        }];
        
        [itemBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(msgLabel.mas_bottom).offset(8);
            make.left.right.equalTo(contentBgView);
            make.height.equalTo(@210);
        }];
        cellHeight += 210;
    }
    else {
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
            make.left.right.equalTo(contentBgView);
            make.height.equalTo(@(itemViewHeight));
        }];
        cellHeight += itemViewHeight;
    }
    
    UIView *bottomBgView = [[UIView alloc] init];
    [contentBgView addSubview:bottomBgView];
    [bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(itemBgView.mas_bottom);
        make.left.right.equalTo(contentBgView);
        make.height.equalTo(@50);
    }];
    
    BOOL condition = YES;
    if (condition) {
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"viedo_icon_colection_nor"] forState:UIControlStateNormal];
        [bottomBgView addSubview:moreBtn];
        [moreBtn addTarget:self action:@selector(moreBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bottomBgView.mas_right).offset(-15);
            make.centerY.equalTo(bottomBgView);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        UILabel *replyLabel = [[UILabel alloc] init];
        replyLabel.textColor = [UIColor colorWithHexString:@"999999"];
        replyLabel.text = @"28328";
        replyLabel.font = [UIFont systemFontOfSize:12.0];
        [bottomBgView addSubview:replyLabel];
        [replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(moreBtn.mas_left).offset(-18);
            make.centerY.equalTo(bottomBgView);
            make.height.equalTo(@15);
        }];
        
        UIButton *replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [replyBtn setBackgroundImage:[UIImage imageNamed:@"viedo_icon_like_nor"] forState:UIControlStateNormal];
        [bottomBgView addSubview:replyBtn];
        [replyBtn addTarget:self action:@selector(replyBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [replyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(replyLabel.mas_left).offset(-5);
            make.centerY.equalTo(bottomBgView);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    else {
        
    }
    
    cellHeight += 50;
    
}

- (CGSize)contentSize:(NSString*)content {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    UIFont *fontContent = [UIFont systemFontOfSize:14.0];
    NSDictionary *dic = @{NSFontAttributeName : fontContent, NSParagraphStyleAttributeName : style};
    CGSize size = [content boundingRectWithSize:CGSizeMake(kScreenWidth - 75, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil].size;
    return size;
}

- (CGFloat)getCellHeight
{
    return cellHeight + 9;
}

- (void)moreBtnDidClick:(id)sender
{
    
}

- (void)replyBtnDidClick:(id)sender
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
