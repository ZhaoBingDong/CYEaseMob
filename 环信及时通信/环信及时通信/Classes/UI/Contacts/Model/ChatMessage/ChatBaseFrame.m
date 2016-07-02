//
//  ChatBaseFrame.m
//  环信及时通信
//
//  Created by dabing on 15/10/10.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "ChatBaseFrame.h"
#import "ChatMessage.h"
#import "ChatMessageBodies.h"
#import "ChatTextFrame.h"
#import "ChatImageFrame.h"
#import "ChatVioceFrame.h"
#import "ChatLocationFrame.h"

@implementation ChatBaseFrame
/**
 *  传个 message模型获取 frame 属性
 *
 *  @param chatMessage  message 模型
 */
- (void)setChatMessage:(ChatMessage *)chatMessage
{
    _chatMessage            = chatMessage;
    // 判断发消息的是不是用户自己
    NSString *from          =  self.chatMessage.from;
    BOOL    isSelf          =  [CMManager isUserSelf:from];
    self.isSelf             = isSelf;
    // 日期 label的模型
    CGFloat dateLabelX      = 0.00f;
    CGFloat dateLabelY      = 10.0f;
    CGFloat dateLabelWidth  = DEF_SCREEN_WIDTH;
    CGFloat dateLabelHeight = 20.0f;
    self.dateLabelFrame = CGRectMake(dateLabelX, dateLabelY, dateLabelWidth, dateLabelHeight);
    // 昵称的位置
    CGFloat nicknameLabelX  = isSelf == YES ?DEF_SCREEN_WIDTH-20-100:20;
    CGFloat nicknameLabelY  = 10.0f;
    CGFloat nicknameWidth   = 100.0f;
    CGFloat nicknameHeight  = 20.0f;
    self.nicknameFrame      = CGRectMake(nicknameLabelX, nicknameLabelY, nicknameWidth, nicknameHeight);
    // 头像的位置
    CGFloat iconViewX       = isSelf == YES?DEF_SCREEN_WIDTH-60:20;
    CGFloat iconViewY       = 30.0f;
    CGFloat iconViewWidth   = 40.0f;
    CGFloat iconViewHeight  = 40.0f;
    self.iconViewFrame      = CGRectMake(iconViewX, iconViewY, iconViewWidth, iconViewHeight);
    // 设置气泡 image
    UIImage *image = self.isSelf == YES?[UIImage imageNamed:@"chat_sender_bg.png"]:[UIImage imageNamed:@"chat_receiver_bg.png"];
    // 设置左边拉伸 和顶部拉伸的程度
    NSInteger leftCapWidth  = self.isSelf == NO?BUBBLE_LEFT_LEFT_CAP_WIDTH:BUBBLE_RIGHT_LEFT_CAP_WIDTH;
    NSInteger topCapHeight  =  self.isSelf == NO?BUBBLE_LEFT_TOP_CAP_HEIGHT:BUBBLE_RIGHT_TOP_CAP_HEIGHT;
    // 设置边帽拉伸
    image = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    self.bubbleimage              = image;
    
}
/**
 *  类方法创建一个 frame 模型
 *
 *  @param message 传一个消息模型进来
 *
 *  @return 返回一个 baseFrame 的模型
 */
+ (instancetype)getChatFrameWithChatMessage:(ChatMessage*)message
{
    ChatBaseFrame *frame = nil;
    MessageBodyType messageBodyType           =  message.messagebodies.messageBodyType;
    if (messageBodyType                       == eMessageBodyType_Text) // 普通文本消息的frame模型
    {
        frame = [ChatTextFrame new];
    }else if (messageBodyType                 == eMessageBodyType_Image)// 图片消息的模型
    {
        frame = [ChatImageFrame new];
    }else if (messageBodyType                 == eMessageBodyType_Voice){// 语音图片的模型
        frame = [ChatVioceFrame new];
    }else if (messageBodyType                 == eMessageBodyType_Location){ //地理位置的消息
        frame = [ChatLocationFrame new];
    }else if (messageBodyType                 == eMessageBodyType_Voice){
        frame = [ChatVioceFrame new];
    }
    frame.chatMessage = message;
    frame.canPlayVoice  = NO;
    return frame;
}
@end
