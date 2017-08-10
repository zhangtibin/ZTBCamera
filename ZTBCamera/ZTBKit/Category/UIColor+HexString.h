//
//  UIColor+HexString.h
//  FortuneTreasure
//
//  Created by Tibin Zhang on 2017/4/12.
//  Copyright © 2017年 Dreams of Ideal World Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)
 NS_ASSUME_NONNULL_BEGIN

+ (UIColor *)colorWithHexString:(NSString *)hexString;//颜色转换 IOS中十六进制的颜色转换为UIColor

+ (NSData *)hexDataWithRGBColor:(UIColor *)color;//颜色转换 UIColor转成十六进制hexData值

+ (UIColor *)colorWithIntValue:(int)intValue;//颜色转换 IOS中十进制的颜色转换为UIColor

+ (UIImage *)imageWithColor:(UIColor *)color;//色值图片

/**
 Creates and returns a color object using the hex RGB color values.
 @param rgbValue  The rgb value such as 0x66ccff.
 @return          The color object. The color information represented by this
 object is in the device RGB colorspace.
 */
+ (UIColor *)colorWithRGB:(uint32_t)rgbValue;

/**
 Creates and returns a color object using the hex RGBA color values.
 @param rgbaValue  The rgb value such as 0x66ccffff.
 @return           The color object. The color information represented by this
 object is in the device RGB colorspace.
 */
+ (UIColor *)colorWithRGBA:(uint32_t)rgbaValue;

/**
 Creates and returns a color object using the specified opacity and RGB hex value.
 @param rgbValue  The rgb value such as 0x66CCFF.
 @param alpha     The opacity value of the color object,
 specified as a value from 0.0 to 1.0.
 @return          The color object. The color information represented by this
 object is in the device RGB colorspace.
 */
+ (UIColor *)colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha;

/**
 Returns the color's RGB value as a hex string (lowercase).
 Such as @"0066cc".
 It will return nil when the color space is not RGB
 @return The color's value as a hex string.
 */
- (nullable NSString *)hexString;

/**
 Returns the color's RGBA value as a hex string (lowercase).
 Such as @"0066ccff".
 It will return nil when the color space is not RGBA
 @return The color's value as a hex string.
 */
- (nullable NSString *)hexStringWithAlpha;

/**
 The color's red component value in RGB color space.
 The value of this property is a float in the range `0.0` to `1.0`.
 */
@property (nonatomic, readonly) CGFloat red;

/**
 The color's green component value in RGB color space.
 The value of this property is a float in the range `0.0` to `1.0`.
 */
@property (nonatomic, readonly) CGFloat green;

/**
 The color's blue component value in RGB color space.
 The value of this property is a float in the range `0.0` to `1.0`.
 */
@property (nonatomic, readonly) CGFloat blue;

/**
 The color's hue component value in HSB color space.
 The value of this property is a float in the range `0.0` to `1.0`.
 */
@property (nonatomic, readonly) CGFloat hue;

/**
 The color's saturation component value in HSB color space.
 The value of this property is a float in the range `0.0` to `1.0`.
 */
@property (nonatomic, readonly) CGFloat saturation;

/**
 The color's brightness component value in HSB color space.
 The value of this property is a float in the range `0.0` to `1.0`.
 */
@property (nonatomic, readonly) CGFloat brightness;

/**
 The color's alpha component value.
 The value of this property is a float in the range `0.0` to `1.0`.
 */
@property (nonatomic, readonly) CGFloat alpha;

/**
 The color's colorspace model.
 */
@property (nonatomic, readonly) CGColorSpaceModel colorSpaceModel;

/**
 Readable colorspace string.
 */
@property (nullable, nonatomic, readonly) NSString *colorSpaceString;

 NS_ASSUME_NONNULL_END
@end
