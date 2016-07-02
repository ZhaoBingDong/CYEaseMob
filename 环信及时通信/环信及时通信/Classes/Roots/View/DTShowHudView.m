//
//  DTShowHudView.m
//  Cinderella
//
//  Created by ng on 15/9/7.
//  Copyright (c) 2015年 Dantou. All rights reserved.
//

#import "DTShowHudView.h"
#import "ShareView.h"
static DTShowHudView *_showHudView;
@interface DTShowHudView ()
<ShareViewDelegate>
/**
 *  是否可以显示 view

 */
@property(nonatomic,assign)BOOL   canShowView;

@end
@implementation DTShowHudView
 ShareView *_showView;
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _showHudView = [super allocWithZone:zone];
        _showHudView.canShowShareView = YES;
    });
    return _showHudView;
}
+ (instancetype)shareHudView
{
    return [[super alloc] init];
}
/**
 *  显示分享视图
 *
 *  @param data    需要分享的参数
 *  @param success 成功的回调
 */
+ (void)showShareViewWithContents:(NSArray*)data successBlock:(void(^)(NSInteger index))success showInView:(UIView*)view;
{
    DTShowHudView *showHudView = [self shareHudView];
    if (showHudView.shareView) {
        return;
    }
    [self creatShareView:data successBlock:success showInView:view];
}
/**
 *  隐藏这个视图
 */
+ (void)hiddenShareView
{
    DTShowHudView *showView = [self shareHudView];
    if (showView.shareView) {
        [showView.shareView removeFromSuperview];
        showView.shareView      = nil;
    }
}
/**
 *  实例化一个分享的 view
 *
 *  @param data     需要分享的参数
 *  @param success 成功的回调
 */
+ (ShareView*)creatShareView:(NSArray*)data successBlock:(void(^)(NSInteger index))success  showInView:(UIView*)view;
{
    DTShowHudView *showView = [self shareHudView];
    if (showView.shareView == nil) {
        showView.shareView = [[ShareView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        showView.shareView.delegate = showView;
        [showView.shareView showShareView:data successBlock:success];
        if (!view) {
            view = [[[UIApplication sharedApplication]delegate]window];
        }
        [view addSubview:showView.shareView];
    }
    return showView.shareView;
}

- (void)shareViewWillHiddenInView
{
    [DTShowHudView hiddenShareView];
    self.canShowShareView = YES;
}

- (void)shareViewWillShowInView
{
    self.canShowShareView   = NO;
}
@end
