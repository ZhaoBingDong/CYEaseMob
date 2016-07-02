//
//  UIView+MHCommon.m
//  PerfectProject
//
//  Created by Meng huan on 14/11/19.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#import "UIView+MHCommon.h"

@implementation UIView (MHCommon)

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)removeAllSubviews
{
    while (self.subviews.count)
    {
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

@end
