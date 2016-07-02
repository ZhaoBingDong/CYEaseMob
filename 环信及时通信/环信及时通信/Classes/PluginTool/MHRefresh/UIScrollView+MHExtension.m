//
//  UIScrollView+MHExtension.m
//  PerfectProject
//
//  Created by Meng huan on 14/11/13.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#import "UIScrollView+MHExtension.h"

@implementation UIScrollView (MHExtension)

- (void)setMh_contentInsetTop:(CGFloat)mh_contentInsetTop
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = mh_contentInsetTop;
    self.contentInset = inset;
}

- (CGFloat)mh_contentInsetTop
{
    return self.contentInset.top;
}

- (void)setMh_contentInsetBottom:(CGFloat)mh_contentInsetBottom
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = mh_contentInsetBottom;
    self.contentInset = inset;
}

- (CGFloat)mh_contentInsetBottom
{
    return self.contentInset.bottom;
}

- (void)setMh_contentInsetLeft:(CGFloat)mh_contentInsetLeft
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = mh_contentInsetLeft;
    self.contentInset = inset;
}

- (CGFloat)mh_contentInsetLeft
{
    return self.contentInset.left;
}

- (void)setMh_contentInsetRight:(CGFloat)mh_contentInsetRight
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = mh_contentInsetRight;
    self.contentInset = inset;
}

- (CGFloat)mh_contentInsetRight
{
    return self.contentInset.right;
}

- (void)setMh_contentOffsetX:(CGFloat)mh_contentOffsetX
{
    CGPoint offset = self.contentOffset;
    offset.x = mh_contentOffsetX;
    self.contentOffset = offset;
}

- (CGFloat)mh_contentOffsetX
{
    return self.contentOffset.x;
}

- (void)setMh_contentOffsetY:(CGFloat)mh_contentOffsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = mh_contentOffsetY;
    self.contentOffset = offset;
}

- (CGFloat)mh_contentOffsetY
{
    return self.contentOffset.y;
}

- (void)setMh_contentSizeWidth:(CGFloat)mh_contentSizeWidth
{
    CGSize size = self.contentSize;
    size.width = mh_contentSizeWidth;
    self.contentSize = size;
}

- (CGFloat)mh_contentSizeWidth
{
    return self.contentSize.width;
}

- (void)setMh_contentSizeHeight:(CGFloat)mh_contentSizeHeight
{
    CGSize size = self.contentSize;
    size.height = mh_contentSizeHeight;
    self.contentSize = size;
}

- (CGFloat)mh_contentSizeHeight
{
    return self.contentSize.height;
}

@end
