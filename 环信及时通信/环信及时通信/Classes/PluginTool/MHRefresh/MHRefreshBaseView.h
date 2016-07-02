//
//  MHRefreshBaseView.h
//  PerfectProject
//
//  Created by Meng huan on 14/11/13.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHRefreshBaseView;

#pragma mark - 控件的刷新状态
typedef enum {
    MHRefreshStatePulling           = 1, // 松开就可以进行刷新的状态
    MHRefreshStateNormal            = 2, // 普通状态
    MHRefreshStateRefreshing        = 3, // 正在刷新中的状态
    MHRefreshStateWillRefreshing    = 4
} MHRefreshState;

#pragma mark - 控件的类型
typedef enum {
    MHRefreshViewTypeHeader = -1,   // 头部控件
    MHRefreshViewTypeFooter = 1     // 尾部控件
} MHRefreshViewType;

/**
 *  类的声明
 */
@interface MHRefreshBaseView : UIView

#pragma mark - 父控件
@property (nonatomic, weak, readonly) UIScrollView *scrollView;
@property (nonatomic, assign, readonly) UIEdgeInsets scrollViewOriginalInset;

#pragma mark - 内部的控件
@property (nonatomic, weak, readonly) UILabel *statusLabel;
@property (nonatomic, weak, readonly) UIImageView *arrowImage;
@property (nonatomic, weak, readonly) UIActivityIndicatorView *activityView;

/**
 *  可以添加自定义加载等待中的效果
 *  1，自定义等待图片、动画、等等
 */
@property (nonatomic, weak, readonly) UIView *customLoadingView;



#pragma mark -
#pragma mark - 回调

/**
 *  开始进入刷新状态的监听器
 */
@property (weak, nonatomic) id beginRefreshingTaget;

/**
 *  开始进入刷新状态的监听方法
 */
@property (assign, nonatomic) SEL beginRefreshingAction;

/**
 *  block 开始进入刷新状态就会调用
 */
@property (nonatomic, copy) void (^beginRefreshingCallback)();

#pragma mark -
#pragma mark - 刷新相关

/**
 *  是否正在刷新
 */
@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;

/**
 *  开始刷新
 */
- (void)beginRefreshing;

/**
 *  结束刷新
 */
- (void)endRefreshing;

#pragma mark -
#pragma mark - 交给子类去实现 和 调用

/**
 *  刷新状态值
 */
@property (assign, nonatomic) MHRefreshState state;

/**
 *  显示文字label的文本
 */
@property (copy, nonatomic) NSString *pullToRefreshText;
@property (copy, nonatomic) NSString *releaseToRefreshText;
@property (copy, nonatomic) NSString *refreshingText;

@end
