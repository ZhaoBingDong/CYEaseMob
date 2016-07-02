//
//  UIColor+MHCommon.h
//  MHProject
//
//  Created by MengHuan on 15/5/18.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (MHCommon)


#pragma mark - 使用二进制颜色值
/**
 *  使用二进制颜色值
 *
 *  @param hex   颜色的二进制值
 *  @param alpha 透明度
 *
 *  @return 颜色
 */
+ (UIColor *)colorWithRGBHex:(UInt32)hex alpha:(CGFloat)alpha;

@end
