//
//  UIImage+MHImageWithColor.m
//  MHProject
//
//  Created by MengHuan on 15/5/11.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import "UIImage+MHImageWithColor.h"

@implementation UIImage (MHImageWithColor)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
