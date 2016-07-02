//
//  MHRefreshConst.h
//  PerfectProject
//
//  Created by Meng huan on 14/11/13.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

/**
 *  自定义常量
 */

#import <UIKit/UIKit.h>

#ifdef DEBUG
#define MHLog(...) NSLog(__VA_ARGS__)
#else
#define MHLog(...)
#endif

// objc_msgSend
#define msgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define msgTarget(target) (__bridge void *)(target)

// 文字颜色
#define MHColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define MHRefreshLabelTextColor MHColor(150, 150, 150)

// 图片路径
#define MHRefreshSrcName(file) [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:file]

UIKIT_EXTERN const CGFloat MHRefreshViewHeight;
UIKIT_EXTERN const CGFloat MHRefreshFastAnimationDuration;
UIKIT_EXTERN const CGFloat MHRefreshSlowAnimationDuration;

UIKIT_EXTERN NSString *const MHRefreshFooterPullToRefresh;
UIKIT_EXTERN NSString *const MHRefreshFooterReleaseToRefresh;
UIKIT_EXTERN NSString *const MHRefreshFooterRefreshing;

UIKIT_EXTERN NSString *const MHRefreshHeaderPullToRefresh;
UIKIT_EXTERN NSString *const MHRefreshHeaderReleaseToRefresh;
UIKIT_EXTERN NSString *const MHRefreshHeaderRefreshing;
UIKIT_EXTERN NSString *const MHRefreshHeaderTimeKey;

UIKIT_EXTERN NSString *const MHRefreshContentOffset;
extern NSString *const MHRefreshContentSize;