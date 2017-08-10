//
//  CameraItemCell.m
//  ZTBCamera
//
//  Created by Tibin Zhang on 2017/5/27.
//  Copyright © 2017年 Xueshan Financial Information Service Co., Ltd. All rights reserved.
//

#import "CameraItemCell.h"

@implementation CameraItemCell
{
    __weak IBOutlet UIImageView *itemImage;
    __weak IBOutlet UILabel *itemLabel;
}

- (void)buildCellWithItemImage:(NSString *)imageName title:(NSString *)title
{
    itemImage.image = [UIImage imageNamed:imageName];
    itemLabel.text = title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
