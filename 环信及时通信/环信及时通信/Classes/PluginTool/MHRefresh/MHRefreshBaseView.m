//
//  MHRefreshBaseView.m
//  PerfectProject
//
//  Created by Meng huan on 14/11/13.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#import "MHRefreshBaseView.h"
#import "MHRefreshConst.h"
#import "UIView+MHExtension.h"
#import "UIScrollView+MHExtension.h"
#import <objc/message.h>

@interface MHRefreshBaseView ()
{
    /**
     *  内部控件
     *  状态label，自定义图片->箭头，loading转圈
     */
    __weak UILabel *_statusLabel;
    __weak UIImageView *_arrowImage;
    __weak UIActivityIndicatorView *_activityView;
    
    // 自定义等待view
    __weak UIView *_customLoadingView;
}
@end

@implementation MHRefreshBaseView

@synthesize state = _state;
@synthesize pullToRefreshText = _pullToRefreshText;
@synthesize releaseToRefreshText = _releaseToRefreshText;
@synthesize refreshingText = _refreshingText;

#pragma mark -
#pragma mark - 状态初始化

- (UILabel *)statusLabel
{
    // 状态标签
    
    if (!_statusLabel) {
        UILabel *statusLabel            = [[UILabel alloc] init];
        statusLabel.autoresizingMask    = UIViewAutoresizingFlexibleWidth;
        statusLabel.font                = [UIFont boldSystemFontOfSize:13];
        statusLabel.textColor           = MHRefreshLabelTextColor;
        statusLabel.backgroundColor     = [UIColor clearColor];
        statusLabel.textAlignment       = NSTextAlignmentCenter;
        [self addSubview:_statusLabel   = statusLabel];
    }
    return _statusLabel;
}

- (UIImageView *)arrowImage
{
    // 自定义图片: 箭头
    
    if (!_arrowImage) {
        UIImageView *arrowImage         = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:MHRefreshSrcName(@"MHRefreshArrow.png")]];
        arrowImage.autoresizingMask     = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_arrowImage    = arrowImage];
    }
    return _arrowImage;
}

- (UIActivityIndicatorView *)activityView
{
    // loading 转圈
    
    if (!_activityView) {
        UIActivityIndicatorView *activityView   = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.bounds                     = self.arrowImage.bounds;
        activityView.autoresizingMask           = self.arrowImage.autoresizingMask;
        [self addSubview:_activityView          = activityView];
    }
    return _activityView;
}

- (UIView *)customLoadingView
{
    // 自定义等待view
    
    if (!_customLoadingView) {
        UIView *customLoadingView           = [[UIView alloc] initWithFrame:self.bounds];
        customLoadingView.backgroundColor   = [UIColor redColor];
        customLoadingView.autoresizingMask  = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_customLoadingView = customLoadingView];
        
        // 添加自己想制作的动画等
        // ...
        
        _customLoadingView.hidden = YES;
    }
    return _customLoadingView;
}

#pragma mark -
#pragma mark - 初始化方法

- (instancetype)initWithFrame:(CGRect)frame
{
    // 赋值view的自定义高度
    frame.size.height = MHRefreshViewHeight;
    
    if (self = [super initWithFrame:frame]) {
        
        // 1.自己的属性
        self.autoresizingMask   = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor    = [UIColor clearColor];
        
        // 2.设置默认状态
        self.state = MHRefreshStateNormal;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /**
     *  内部调整子视图位置
     */
    
    // 1.箭头
    CGFloat arrowX = self.mh_width * 0.5 - 100;
    self.arrowImage.center = CGPointMake(arrowX, self.mh_height * 0.5);
    
    // 2.指示器
    self.activityView.center = self.arrowImage.center;
    
    // 3.自定义等待view
    self.customLoadingView.center = CGPointMake(self.mh_width * 0.5, self.mh_height * 0.5);
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    /**
     *  移出父视图时的处理
     */
    
    // 旧的父控件
    [self.superview removeObserver:self forKeyPath:MHRefreshContentOffset context:nil];
    
    if (newSuperview) {
        
        // 新的父控件
        [newSuperview addObserver:self forKeyPath:MHRefreshContentOffset options:NSKeyValueObservingOptionNew context:nil];
        
        // 设置宽度
        self.mh_width = newSuperview.mh_width;
        
        // 设置位置
        self.mh_x = 0;
        
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        
        // 记录UIScrollView最开始的contentInset
        _scrollViewOriginalInset = _scrollView.contentInset;
    }
}

#pragma mark - 显示到屏幕上
- (void)drawRect:(CGRect)rect
{
    // 更改状态
    if (self.state == MHRefreshStateWillRefreshing) {
        
        self.state = MHRefreshStateRefreshing;
    }
}

#pragma mark -
#pragma mark - 刷新相关

- (BOOL)isRefreshing
{
    // 是否正在刷新
    
    return MHRefreshStateRefreshing == self.state;
}

- (void)beginRefreshing
{
    // 开始刷新
    
    if (self.state == MHRefreshStateRefreshing) {
        
        // 回调
        if ([self.beginRefreshingTaget respondsToSelector:self.beginRefreshingAction]) {
            
            msgSend(msgTarget(self.beginRefreshingTaget), self.beginRefreshingAction, self);
        }
        
        // block
        if (self.beginRefreshingCallback) {
            
            self.beginRefreshingCallback();
        }
        
    } else {
        
        if (self.window) {
            
            self.state = MHRefreshStateRefreshing;
            
        } else {
            
//#warning 不能调用set方法
            // 不能调用set方法
            _state = MHRefreshStateWillRefreshing;
            
//#warning 为了保证在viewWillAppear等方法中也能刷新
            // 为了保证在viewWillAppear等方法中也能刷新
            [self setNeedsDisplay];
        }
    }
}

- (void)endRefreshing
{
    // 结束刷新
    
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        // 重置状态
        self.state = MHRefreshStateNormal;
    });
}


#pragma mark -
#pragma mark - 设置文字显示状态

- (void)setPullToRefreshText:(NSString *)pullToRefreshText
{
    _pullToRefreshText = [pullToRefreshText copy];
    [self settingLabelText];
}

- (void)setReleaseToRefreshText:(NSString *)releaseToRefreshText
{
    _releaseToRefreshText = [releaseToRefreshText copy];
    [self settingLabelText];
}

- (void)setRefreshingText:(NSString *)refreshingText
{
    _refreshingText = [refreshingText copy];
    [self settingLabelText];
}

- (void)settingLabelText
{
    switch (self.state) {
            
        case MHRefreshStateNormal:
            // 设置文字
            self.statusLabel.text = self.pullToRefreshText;
            break;
            
        case MHRefreshStatePulling:
            // 设置文字
            self.statusLabel.text = self.releaseToRefreshText;
            break;
            
        case MHRefreshStateRefreshing:
            // 设置文字
            self.statusLabel.text = self.refreshingText;
            break;
            
        default:
            break;
    }
}

- (void)setState:(MHRefreshState)state
{
    // 0.存储当前的contentInset
    if (self.state != MHRefreshStateRefreshing) {
        _scrollViewOriginalInset = self.scrollView.contentInset;
    }
    
    // 1.一样的就直接返回(暂时不返回)
    if (self.state == state) return;
    
    // 2.旧状态
    MHRefreshState oldState = self.state;
    
    // 3.存储状态
    _state = state;
    
    // 4.根据状态执行不同的操作
    switch (state) {
        case MHRefreshStateNormal: // 普通状态
        {
            if (oldState == MHRefreshStateRefreshing) {
                [UIView animateWithDuration:MHRefreshSlowAnimationDuration * 0.6 animations:^{
                    self.activityView.alpha = 0.0;
                } completion:^(BOOL finished) {
                    // 停止转圈圈
                    [self.activityView stopAnimating];
                    
                    // 恢复alpha
                    self.activityView.alpha = 1.0;
                }];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MHRefreshSlowAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 等头部回去
                    
                    // 显示箭头
                    self.arrowImage.hidden = NO;
                    
                    // 停止转圈圈
                    [self.activityView stopAnimating];
                    
                    // 设置文字
                    [self settingLabelText];
                });
                // 直接返回
                return;
            } else {
                // 显示箭头
                self.arrowImage.hidden = NO;
                
                // 停止转圈圈
                [self.activityView stopAnimating];
            }
            break;
        }
            
        case MHRefreshStatePulling:
            break;
            
        case MHRefreshStateRefreshing:
        {
            // 开始转圈圈
            [self.activityView startAnimating];
            // 隐藏箭头
            self.arrowImage.hidden = YES;
            
            // 回调
            if ([self.beginRefreshingTaget respondsToSelector:self.beginRefreshingAction]) {
                msgSend(msgTarget(self.beginRefreshingTaget), self.beginRefreshingAction, self);
            }
            
            if (self.beginRefreshingCallback) {
                self.beginRefreshingCallback();
            }
            break;
        }
        default:
            break;
    }
    
    // 5.设置文字
    [self settingLabelText];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
