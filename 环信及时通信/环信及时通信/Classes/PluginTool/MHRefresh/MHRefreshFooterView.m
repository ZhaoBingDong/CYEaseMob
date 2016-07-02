//
//  MHRefreshFooterView.m
//  PerfectProject
//
//  Created by Meng huan on 14/11/13.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#import "MHRefreshFooterView.h"
#import "MHRefreshConst.h"
#import "UIView+MHExtension.h"
#import "UIScrollView+MHExtension.h"

@interface MHRefreshBaseView ()

@end

@implementation MHRefreshFooterView

+ (instancetype)footer
{
    return [[MHRefreshFooterView alloc] init];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.pullToRefreshText      = MHRefreshFooterPullToRefresh;
        self.releaseToRefreshText   = MHRefreshFooterReleaseToRefresh;
        self.refreshingText         = MHRefreshFooterRefreshing;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.statusLabel.frame = self.bounds;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 旧的父控件
    [self.superview removeObserver:self forKeyPath:MHRefreshContentSize context:nil];
    
    if (newSuperview) { // 新的父控件
        // 监听
        [newSuperview addObserver:self forKeyPath:MHRefreshContentSize options:NSKeyValueObservingOptionNew context:nil];
        
        // 重新调整frame
        [self adjustFrameWithContentSize];
    }
}

#pragma mark - 重写调整frame
- (void)adjustFrameWithContentSize
{
    // 内容的高度
    CGFloat contentHeight   = self.scrollView.mh_contentSizeHeight;
    
    // 表格的高度
    CGFloat scrollHeight    = self.scrollView.mh_height - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom;
    
    // 设置位置和尺寸
    self.mh_y = MAX(contentHeight, scrollHeight);
}

#pragma mark 监听UIScrollView的属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 不能跟用户交互，直接返回
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden) return;
    
    if ([MHRefreshContentSize isEqualToString:keyPath]) {
        // 调整frame
        [self adjustFrameWithContentSize];
    } else if ([MHRefreshContentOffset isEqualToString:keyPath]) {
//#warning 这个返回一定要放这个位置
        // 这个返回一定要放这个位置
        // 如果正在刷新，直接返回
        if (self.state == MHRefreshStateRefreshing) return;
        
        // 调整状态
        [self adjustStateWithContentOffset];
    }
}

#pragma mark - 调整状态
- (void)adjustStateWithContentOffset
{
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.mh_contentOffsetY;
    // 尾部控件刚好出现的offsetY
    CGFloat happenOffsetY = [self happenOffsetY];
    
    // 如果是向下滚动到看不见尾部控件，直接返回
    if (currentOffsetY <= happenOffsetY) return;
    
    if (self.scrollView.isDragging) {
        // 普通 和 即将刷新 的临界点
        CGFloat normal2pullingOffsetY = happenOffsetY + self.mh_height;
        
        if (self.state == MHRefreshStateNormal && currentOffsetY > normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.state = MHRefreshStatePulling;
        } else if (self.state == MHRefreshStatePulling && currentOffsetY <= normal2pullingOffsetY) {
            // 转为普通状态
            self.state = MHRefreshStateNormal;
        }
    } else if (self.state == MHRefreshStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
        self.state = MHRefreshStateRefreshing;
    }
}

#pragma mark -
#pragma mark - 状态相关

- (void)setState:(MHRefreshState)state
{
    // 1.一样的就直接返回
    if (self.state == state) return;
    
    // 2.保存旧状态
    MHRefreshState oldState = self.state;
    
    // 3.调用父类方法
    [super setState:state];
    
    // 4.根据状态来设置属性
    switch (state)
    {
        case MHRefreshStateNormal:
        {
            // 刷新完毕
            if (MHRefreshStateRefreshing == oldState) {
                self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
                [UIView animateWithDuration:MHRefreshSlowAnimationDuration animations:^{
                    self.scrollView.mh_contentInsetBottom = self.scrollViewOriginalInset.bottom;
                }];
            } else {
                // 执行动画
                [UIView animateWithDuration:MHRefreshFastAnimationDuration animations:^{
                    self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
                }];
            }
            
            CGFloat deltaH          = [self heightForContentBreakView];
            NSInteger currentCount  = [self totalDataCountInScrollView];
            // 刚刷新完毕
            if (MHRefreshStateRefreshing == oldState && deltaH > 0 && currentCount != self.lastRefreshCount) {
                self.scrollView.mh_contentOffsetY = self.scrollView.mh_contentOffsetY;
            }
            break;
        }
            
        case MHRefreshStatePulling:
        {
            [UIView animateWithDuration:MHRefreshFastAnimationDuration animations:^{
                self.arrowImage.transform = CGAffineTransformIdentity;
            }];
            break;
        }
            
        case MHRefreshStateRefreshing:
        {
            // 记录刷新前的数量
            self.lastRefreshCount = [self totalDataCountInScrollView];
            
            [UIView animateWithDuration:MHRefreshFastAnimationDuration animations:^{
                CGFloat bottom = self.mh_height + self.scrollViewOriginalInset.bottom;
                CGFloat deltaH = [self heightForContentBreakView];
                if (deltaH < 0) { // 如果内容高度小于view的高度
                    bottom -= deltaH;
                }
                self.scrollView.mh_contentInsetBottom = bottom;
            }];
            break;
        }
            
        default:
            break;
    }
}

- (NSInteger)totalDataCountInScrollView
{
    NSInteger totalCount = 0;
    if ([self.scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self.scrollView;
        
        for (NSInteger section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self.scrollView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self.scrollView;
        
        for (NSInteger section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

#pragma mark 获得scrollView的内容 超出 view 的高度
- (CGFloat)heightForContentBreakView
{
    CGFloat h = self.scrollView.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top;
    return self.scrollView.contentSize.height - h;
}

#pragma mark - 在父类中用得上
/**
 *  刚好看到上拉刷新控件时的contentOffset.y
 */
- (CGFloat)happenOffsetY
{
    CGFloat deltaH = [self heightForContentBreakView];
    if (deltaH > 0) {
        return deltaH - self.scrollViewOriginalInset.top;
    } else {
        return - self.scrollViewOriginalInset.top;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
