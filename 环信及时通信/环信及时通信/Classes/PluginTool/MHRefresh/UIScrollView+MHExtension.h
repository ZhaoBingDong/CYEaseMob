//
//  UIScrollView+MHExtension.h
//  PerfectProject
//
//  Created by Meng huan on 14/11/13.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

/**
 *  MH UIScrollView 扩展
 */

#import <UIKit/UIKit.h>

@interface UIScrollView (MHExtension)

@property (assign, nonatomic) CGFloat mh_contentInsetTop;
@property (assign, nonatomic) CGFloat mh_contentInsetBottom;
@property (assign, nonatomic) CGFloat mh_contentInsetLeft;
@property (assign, nonatomic) CGFloat mh_contentInsetRight;

@property (assign, nonatomic) CGFloat mh_contentOffsetX;
@property (assign, nonatomic) CGFloat mh_contentOffsetY;

@property (assign, nonatomic) CGFloat mh_contentSizeWidth;
@property (assign, nonatomic) CGFloat mh_contentSizeHeight;

@end
