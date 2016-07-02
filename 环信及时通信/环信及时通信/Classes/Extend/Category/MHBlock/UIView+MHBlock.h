//
//  UIView+MHBlock.h
//  MHProject
//
//  Created by MengHuan on 15/6/5.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MHBlock) <UIAlertViewDelegate, UIActionSheetDelegate>

// UIAlertView
- (void)showWithCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

// UIActionSheet
- (void)showInView:(UIView *)view withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

- (void)showFromToolbar:(UIToolbar *)view withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

- (void)showFromTabBar:(UITabBar *)view withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

- (void)showFromRect:(CGRect)rect
              inView:(UIView *)view
            animated:(BOOL)animated
withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

- (void)showFromBarButtonItem:(UIBarButtonItem *)item
                     animated:(BOOL)animated
        withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

@end
