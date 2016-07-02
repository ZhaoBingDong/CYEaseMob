//
//  UIColor+MHCommon.m
//  MHProject
//
//  Created by MengHuan on 15/5/18.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import "UIColor+MHCommon.h"

@implementation UIColor (MHCommon)


#pragma mark - 使用二进制颜色值
/**
 *  使用二进制颜色值
 *
 *  @param hex   颜色的二进制值
 *  @param alpha 透明度
 *
 *  @return 颜色
 */
+ (UIColor *)colorWithRGBHex:(UInt32)hex alpha:(CGFloat)alpha
{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:alpha];
}

@end
