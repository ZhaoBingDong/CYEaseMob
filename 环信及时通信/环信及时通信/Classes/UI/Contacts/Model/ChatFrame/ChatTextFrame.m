//
//  ChatTextFrame.m
//  环信及时通信
//
//  Created by dabing on 15/10/10.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "ChatTextFrame.h"
#import "ChatMessage.h"
#import "ChatMessageBodies.h"
#define MAX_MESSAGELABEL_WIDTH (CGFloat)DEF_SCREEN_WIDTH *0.6
@implementation ChatTextFrame

- (void)setChatMessage:(ChatMessage *)chatMessage
{
    [super setChatMessage:chatMessage];
    
    // 消息 label的位置
    CGFloat messageLabelX   = self.isSelf == YES ?5.0f :15.0f;
    CGFloat messageLabelY   = 6.0f;
    CGSize textSize         = [self getMessgeContentSize:self.chatMessage.messagebodies.text];
    CGFloat messageWidth    = textSize.width+10;
    CGFloat messageHeight   = textSize.height;
    self.contentLabelFrame  = CGRectMake(messageLabelX, messageLabelY, messageWidth, messageHeight);
    // 气泡的位置
    CGFloat bubbleViewY     = 50.0f;
    CGFloat bubbleWidth     = messageWidth+20;
    CGFloat bubbleHeight    = messageHeight+15;
    CGFloat bubbleViewX     = self.isSelf == YES?DEF_SCREEN_WIDTH-80-bubbleWidth:80;
    self.bubbleViewFrame    = CGRectMake(bubbleViewX, bubbleViewY, bubbleWidth, bubbleHeight);
    // 返回单元格的高度
    self.cellHeight = bubbleViewY + bubbleHeight+10;
}
/**
 *  计算文字的大小
 *
 *  @param message 消息
 *
 *  @return 返回文字的尺寸
 */
- (CGSize)getMessgeContentSize:(NSString*)message
{
  NSAttributedString *string = [HMDatabaseTool getAttributedString:message];
  return  [message getAttributedTextSizeWithRestrictWidth:MAX_MESSAGELABEL_WIDTH withString:string];
}
@end
