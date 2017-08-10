//
//  PhotoResourceCell.m
//  ZTBCamera
//
//  Created by Tibin Zhang on 2017/6/1.
//  Copyright © 2017年 Xueshan Financial Information Service Co., Ltd. All rights reserved.
//

#import "PhotoResourceCell.h"

@implementation PhotoResourceCell
{
    __weak IBOutlet UIImageView *resourceImage;
    
}

- (void)buildCellWithItem:(UIImage *)itemImage
{
    resourceImage.image = itemImage;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
