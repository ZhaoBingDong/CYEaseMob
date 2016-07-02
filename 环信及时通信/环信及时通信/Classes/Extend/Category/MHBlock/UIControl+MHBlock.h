//
//  UIControl+MHBlock.h
//  MHProject
//
//  Created by MengHuan on 15/6/5.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (MHBlock)

- (void)handleControlEvent:(UIControlEvents)event withBlock:(void(^)(id sender))block;
- (void)removeHandlerForEvent:(UIControlEvents)event;

@end
