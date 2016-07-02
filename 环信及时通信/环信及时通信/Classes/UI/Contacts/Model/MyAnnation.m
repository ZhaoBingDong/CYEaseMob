//
//  MyAnnation.m
//  PerfectProject
//
//  Created by yons on 15/6/14.
//  Copyright (c) 2015年 M.H Co.,Ltd. All rights reserved.
//

#import "MyAnnation.h"

@implementation MyAnnation

- (void)setTitle:(NSString *)title
{
    _title = title;
}
-(void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate  = newCoordinate;
}

@end
