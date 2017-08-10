//
//  SpacingLabel.h
//  XSD
//
//  Created by Tibin Zhang on 16/7/5.
//  Copyright © 2016年 Xueshan Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Class 描述: 自定义具有高度间隔,总高度动态的Label
 */
@interface SpacingLabel : UILabel

@property (nonatomic, assign) CGFloat spacingHeight;//高度间隔
@property (nonatomic, assign) CGSize contentSize;
- (CGSize)contentSize:(NSString*)content;
- (CGSize)contentSize;


@end
