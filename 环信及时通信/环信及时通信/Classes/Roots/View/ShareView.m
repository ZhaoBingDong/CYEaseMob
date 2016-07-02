//
//  ShareView.m
//  Cinderella
//
//  Created by ng on 15/9/7.
//  Copyright (c) 2015年 Dantou. All rights reserved.
//

#import "ShareView.h"
#import "UIView+MHCommon.h"
#import "MHViewDefine.h"
@interface ShareView ()
{
    BOOL _canShowView;
}
@end

@implementation ShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _canShowView = YES;
    }
    return self;
}
/**
 *   弹出分享的视图
 *
 *  @param params  分享参数
 *  @param success 成功后的回调
 */
- (void)showShareView:(NSArray*)params successBlock:(void(^)())success;
{
    self.success = success;
    self.params  = params;
    [self removeAllSubviews];
    [self creatUI];
    if ([self.delegate respondsToSelector:@selector(shareViewWillShowInView)]) {
        [self.delegate shareViewWillShowInView];
    }
    [UIView animateWithDuration:KShowViewDuritionTime animations:^{
        self.coverView.alpha = 0.3;
        self.bgView.frame = CGRectMake(0, DEF_SCREEN_HEIGHT-self.bgView.frame.size.height, DEF_SCREEN_WIDTH,self.bgView.frame.size.height);
    }];
}
/**
 *  隐藏分享视图
 */
- (void)hiddenShareView
{
    [UIView animateWithDuration:KShowViewDuritionTime animations:^{
        [self.bgView setFrame:CGRectMake(0, DEF_SCREEN_HEIGHT, DEF_SCREEN_WIDTH, self.bgView.frame.size.height)];
    }completion:^(BOOL finished)
    {
        [self removeFromSuperview];
    }];
    if ([self.delegate respondsToSelector:@selector(shareViewWillHiddenInView)]) {
        [self.delegate shareViewWillHiddenInView];
    }
}
/**
 *  点击遮盖处移除分享的界面
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hiddenShareView];
}
/**
 *  点击了三个不同分享平台的按钮˜
 */
- (void)shareBtnClick:(UIButton*)btn
{
    [self hiddenShareView];
    if (self.success)
    {
        self.success(btn.tag);
    }
}
/**
 *  创建 UI
 */
- (void)creatUI
{
    // 黑色的遮盖
    self.coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT)];
    self.coverView.backgroundColor = [UIColor blackColor];
    self.coverView.alpha = 0;
    [self addSubview:self.coverView];
    // 放分享按钮的背景View
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, DEF_SCREEN_HEIGHT, DEF_SCREEN_WIDTH, 200)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    // titleLabel
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,20, DEF_SCREEN_WIDTH, 20)];
    self.titleLabel.text = @"操作选项";
    self.titleLabel.textColor = [UIColor lightGrayColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = FOUN_SIZE(15);
    [self.bgView addSubview:self.titleLabel];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *name in self.params) {
        UIImage *im = [UIImage imageNamed:name];
        [tempArray addObject:im];
    }
    // 分享按钮的图片
    UIImage *image =  tempArray[0];
    CGSize size = image.size;
    NSInteger itemCountInRow = KShowViewItemCountInRow;
    if (itemCountInRow>5) {
        itemCountInRow = 5;
    }
    CGFloat width = DEF_SCREEN_WIDTH/itemCountInRow;
    CGFloat height = size.height;
    CGFloat lastButtonY = 0.0f;
    for (int i =0; i<tempArray.count; i++)
    {
        CGFloat buttonY  = [self.titleLabel bottom]+20+(height+15)*(i/itemCountInRow);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setImage:tempArray[i] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0+(width)*(i%itemCountInRow),buttonY , width, height)];
        [button addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:button];
        lastButtonY     = buttonY;
    }
    // 横线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, lastButtonY+height+30, DEF_SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.5;
    [self.bgView addSubview:lineView];
    
    // 取消
    self.cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancel setFrame:CGRectMake(0, [lineView bottom], DEF_SCREEN_WIDTH, 60)];
    [self.cancel setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancel setTitleColor:DEF_RGB_COLOR(11, 80, 186) forState:UIControlStateNormal];
    [self.cancel addTarget:self action:@selector(hiddenShareView) forControlEvents:UIControlEventTouchUpInside];
    self.cancel.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:self.cancel];
    
    CGFloat bgViewHeight = [self.cancel bottom];
    [self.bgView setFrame:CGRectMake(0, DEF_SCREEN_HEIGHT, DEF_SCREEN_WIDTH, bgViewHeight)];
}


@end
