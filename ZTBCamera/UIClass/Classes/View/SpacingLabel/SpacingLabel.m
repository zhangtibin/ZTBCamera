//
//  SpacingLabel.m
//  XSD
//
//  Created by Tibin Zhang on 16/7/5.
//  Copyright © 2016年 Xueshan Financial Information Service Co., Ltd. All rights reserved.
//

#import "SpacingLabel.h"

#import "UIColor+HexString.h"

@implementation SpacingLabel
{
    CGSize labelSizes;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setText:(NSString *)text
{
    self.numberOfLines = 0;
    labelSizes = CGSizeZero;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:self.spacingHeight];
    NSMutableAttributedString *attributedString =  [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSKernAttributeName : @(0.5f)}];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    self.attributedText = attributedString;
    CGSize size = CGSizeMake(self.frame.size.width, 500000);
    CGSize labelSize = [self sizeThatFits:size];
    labelSizes = labelSize;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, labelSize.width, labelSize.height);
}

- (CGSize)contentSize{
    return labelSizes;
}

- (CGSize)contentSize:(NSString*)content {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:self.spacingHeight];
    NSMutableAttributedString *attributedString =  [[NSMutableAttributedString alloc] initWithString:content attributes:@{NSKernAttributeName : @(0.5f)}];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
    self.attributedText = attributedString;
    CGSize size = CGSizeMake(self.frame.size.width, 500000);
    CGSize labelSize = [self sizeThatFits:size];
    return labelSize;
}


@end
