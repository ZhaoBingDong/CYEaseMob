//
//  ChatDetailActionView.m
//  环信及时通信
//
//  Created by dabing on 15/10/9.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "ChatDetailActionView.h"

@implementation ChatDetailActionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 单元格
        UIControl *cell = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 44)];
        [cell addTarget:self action:@selector(didSelectBlackList) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cell];
        self.cell       = cell;
        // titleLabel
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 44)];
        self.titleLabel.text   = @"群组黑名单";
        [cell addSubview:self.titleLabel];
        // imageView
        self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DEF_SCREEN_WIDTH-28, (44-14)/2, 8, 14)];
        [self.arrowImageView setImage:[UIImage imageNamed:@"order_pay_arrow"]];
        [cell addSubview:self.arrowImageView];
        // 解散群组
        self.closeGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeGroupBtn setFrame:CGRectMake(20, frame.size.height-60, frame.size.width-40, 40)];
        [self.closeGroupBtn setTitle:@"解散群组" forState:UIControlStateNormal];
        [self.closeGroupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.closeGroupBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.closeGroupBtn addTarget:self action:@selector(closeGroupClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.closeGroupBtn setBackgroundColor:[UIColor redColor]];
        [self addSubview:self.closeGroupBtn];
        // 清空聊天记录的按钮
        self.cleanChatRocord = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cleanChatRocord setFrame:CGRectMake(20, [self.closeGroupBtn top]-70, frame.size.width-40, 40)];
        [self.cleanChatRocord setTitle:@"清空聊天记录" forState:UIControlStateNormal];
        [self.cleanChatRocord setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.cleanChatRocord.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.cleanChatRocord addTarget:self action:@selector(cleanChatRocordClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.cleanChatRocord setBackgroundColor:DEF_TABBAR_COLOR];
        [self addSubview:self.cleanChatRocord];
    }
    return self;
}

/**
 *  解散群组
 */
- (void)closeGroupClick:(UIButton*)btn
{
    if ([self.delegate respondsToSelector:@selector(chatDetailActionViewDidSelctCloseChatGourp)]) {
        [self.delegate chatDetailActionViewDidSelctCloseChatGourp];
    }
}
/**
 *  清除聊天记录
 */
- (void)cleanChatRocordClick:(UIButton*)btn
{
    if ([self.delegate respondsToSelector:@selector(chatDetailActionViewDidSelctCleanAllChatRecord)]) {
        [self.delegate chatDetailActionViewDidSelctCleanAllChatRecord];
    }
}
/**
 *  群组黑名单
 */
- (void)didSelectBlackList
{
    if ([self.delegate respondsToSelector:@selector(chatDetailActionViewDidSelctGroupBlackList)])
    {
        [self.delegate chatDetailActionViewDidSelctGroupBlackList];
    }
}

- (void)setOwer:(BOOL)ower
{
    _ower   = ower;
    if (_ower == NO) {
        [self.closeGroupBtn removeFromSuperview];
        self.closeGroupBtn = nil;
        [self.cell removeFromSuperview];
        self.cell          = nil;
        [self.cleanChatRocord setY:(self.frame.size.height-40)/2];
    }
}
@end
