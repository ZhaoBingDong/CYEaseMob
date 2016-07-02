//
//  DTShowProgressView.h
//  环信及时通信
//
//  Created by dabing on 15/10/13.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DTShowTaskType) {
    DTShowTaskTypeCoverView = 1, // 有遮盖
    DTShowTaskTypeClear     = 2 // 没有遮盖
};
/**
 *  显示进度的 view
 */
@interface DTShowProgressView : UIView
/**
 *  显示进度的 view
 */
@property(nonatomic,strong)UIView *shareView;

/**
 *  显示进度指示器
 *
 *  @param view   加载这个 view的视图
 *  @param status 文本
 */
+ (void)showInView:(UIView*)view  withStatus:(NSString*)status;
/**
 *  只是简单的转个圈圈
 *
 *  @param view 显示这个 view 的视图
 */
+ (void)showInView:(UIView*)view;
/**
 *  显示进度指示器
 *
 *  @param view     显示这个 view 的视图
 *  @param tastType 任务类型
 *  @param status   文本
 */
+ (void)showInView:(UIView*)view maskType:(DTShowTaskType)tastType withStatus:(NSString*)status;
/**
 *  消失了
 */
+ (void)dissmiss;

@end
