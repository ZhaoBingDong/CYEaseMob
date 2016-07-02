//
//  UILabel+Category.m
//  BlueMobiProject
//
//  Created by wangluhong on 14/12/1.
//  Copyright (c) 2014年 朱 亮亮. All rights reserved.
//

#import "UILabel+Category.h"

@implementation UILabel (Category)
#pragma mark- 动态计算文字大小

-(CGSize)getTextSizeWithFont:(UIFont*)font restrictWidth:(float)width     withString:(NSString*)string
{
    //动态计算文字大小
    NSDictionary *oldDict = @{NSFontAttributeName:font};
    CGSize oldPriceSize = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:oldDict context:nil].size;
    return oldPriceSize;
}
@end
