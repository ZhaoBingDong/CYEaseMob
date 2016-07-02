//
//  UILabel+Category.h
//  BlueMobiProject
//
//  Created by wangluhong on 14/12/1.
//  Copyright (c) 2014年 朱 亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Category)
/**
 *  计算 label 字体的尺寸
 *
 *  @param font   字体大小
 *  @param string 文字内容
 *  @param width   限定文字的宽度
 *  @return 返回一个 CGSize类型结构体
 */
-(CGSize)getTextSizeWithFont:(UIFont*)font restrictWidth:(float)width     withString:(NSString*)string;


@end
