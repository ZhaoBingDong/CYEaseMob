//
//  DTShowProgressView.m
//  环信及时通信
//
//  Created by dabing on 15/10/13.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "DTShowProgressView.h"
@interface DTShowProgressView ()
/**
 *  进度显示器
 */
@property(nonatomic,strong)UIActivityIndicatorView *activityView;
/**
 *  遮盖
 */
@property(nonatomic,strong)UIView                  *coverView;

@end
@implementation DTShowProgressView

/// 类方法创建实例
+ (instancetype)shareProgressView
{
    return [[super alloc] init];
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static DTShowProgressView *_progerssView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _progerssView   = [super allocWithZone:zone];
    });
    return _progerssView;
}
/// 懒加载 shareView
- (UIView *)shareView
{
    if (!_shareView) {
        _shareView = [[UIView alloc] init];
        _shareView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
        _shareView.clipsToBounds          = YES;
        _shareView.hidden                 = YES;
        _activityView   = [[UIActivityIndicatorView alloc] init];
        _activityView.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleWhiteLarge;
        [_activityView startAnimating];
        _activityView.bounds                     = CGRectMake(0, 0, 40, 40);
        [_shareView addSubview:_activityView];
        _shareView.tag                           = 200000;
    }
    return _shareView;
}
/// 懒加载遮盖的 view
- (UIView *)coverView
{
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _coverView.tag             = 100000;
    }
    return _coverView;
}
/**
 *  显示进度指示器
 *
 *  @param view   加载这个view的视图
 *  @param status 文本
 */
+ (void)showInView:(UIView*)view  withStatus:(NSString*)status
{
    [self showInView:view maskType:0 withStatus:status];
}
/**
 *  只是简单的转个圈圈
 *
 *  @param view显示这个view的视图
 */
+ (void)showInView:(UIView*)view
{
    [self showInView:view maskType:0 withStatus:nil];
}
/**
 *  开始显示这个 view
 *
 *  @param view   加载这个view的控制器
 *  @param status 要显示的文本
 */
+ (void)showInView:(UIView*)view maskType:(DTShowTaskType)tastType withStatus:(NSString*)status
{
    DTShowProgressView *progressView = [DTShowProgressView shareProgressView];
    // 把旧的 view 给移除了 
    if (progressView.shareView) {
        [progressView.shareView removeFromSuperview];
        progressView.shareView = nil;
    }
    if (!view||view.frame.size.width>[UIScreen mainScreen].bounds.size.width) {
        view = [[[UIApplication sharedApplication] delegate]window];
    }
    if (tastType == DTShowTaskTypeCoverView)
    {
        UIView *coverVeiw = [view viewWithTag:100000];
        [coverVeiw removeFromSuperview];
        progressView.coverView.hidden = NO;
        [view addSubview:progressView.coverView];
    }
    progressView.shareView.hidden = NO;
    [view addSubview:progressView.shareView];
    CGFloat shareViewWidth        = 100;
    CGFloat shareViewHeight       = 100;
    CGFloat shareViewX            = 0.0f;
    CGFloat shareViewY            = 0.0f;
    if (!status||[status isEqualToString:@""]) {
        shareViewX = (view.frame.size.width -100)/2;
        shareViewY = (view.frame.size.height - 100)/2;
        [progressView.shareView setFrame:CGRectMake(shareViewX, shareViewY, shareViewWidth, shareViewHeight)];
        progressView.shareView.layer.cornerRadius = shareViewWidth*0.03;
        progressView.layer.masksToBounds     = YES;
        progressView.activityView.center     = CGPointMake(shareViewWidth/2, shareViewHeight/2);
    }else
    {
        // 计算文字的高度
        CGSize textSize         = [progressView getTextSizeWithFont:[UIFont systemFontOfSize:15] restrictWidth:200 withString:status];
        CGFloat labelX          = 10;
        CGFloat labelY          = 50;
        CGFloat labelWidth      = textSize.width;
        CGFloat labelHeight     = textSize.height;
        UILabel *label          = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelWidth, labelHeight)];
        label.font              = [UIFont systemFontOfSize:15];
        label.textColor         = [UIColor whiteColor];
        label.numberOfLines     = 0;
        label.textAlignment     = NSTextAlignmentCenter;
        label.text              = status;
        [progressView.shareView addSubview:label];
        // 重写设置活动指示器的位置
        shareViewY              = (view.frame.size.height - labelHeight-60)/2;
        shareViewHeight         = labelHeight +labelY +15;
        shareViewWidth          = labelWidth + 20;
        shareViewX              = (view.frame.size.width - shareViewWidth)/2;
        [progressView.shareView setFrame:CGRectMake(shareViewX, shareViewY,shareViewWidth, shareViewHeight)];
        progressView.shareView.layer.cornerRadius = shareViewHeight*0.08;
        [progressView.activityView setCenter:CGPointMake(shareViewWidth/2, 30)];
    }
}
/**
 *  消失了
 */
+ (void)dissmiss
{
    DTShowProgressView *progressView = [DTShowProgressView shareProgressView];
    progressView.shareView.hidden                 = YES;
    progressView.coverView.hidden                 = YES;
    progressView.shareView                        = nil;
}
/**
 *  计算 label 字体的尺寸
 *
 *  @param font   字体大小
 *  @param string 文字内容
 *  @param width   限定文字的宽度
 *  @return 返回一个 CGSize类型结构体
 */
-(CGSize)getTextSizeWithFont:(UIFont*)font restrictWidth:(float)width   withString:(NSString*)string
{
    //动态计算文字大小
    NSDictionary *oldDict = @{NSFontAttributeName:font};
    CGSize oldPriceSize = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:oldDict context:nil].size;
    return oldPriceSize;
}
@end
