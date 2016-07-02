//
//  CustomButton.m
//  环信及时通信
//
//  Created by dabing on 15/10/12.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeFromSuperView" object:self];
}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
