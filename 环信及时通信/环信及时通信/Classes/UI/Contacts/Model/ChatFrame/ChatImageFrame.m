//
//  ChatImageFrame.m
//  环信及时通信
//
//  Created by dabing on 15/10/10.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "ChatImageFrame.h"
#import "ChatMessage.h"
#import "ChatMessageBodies.h"

@implementation ChatImageFrame

- (void)setChatMessage:(ChatMessage *)chatMessage
{
    [super setChatMessage:chatMessage];
    
    // 接收到图片的尺寸
    CGFloat imageViewWidth  = (chatMessage.messagebodies.thumbnailWidth)*1.3;
    CGFloat imageViewHeight = chatMessage.messagebodies.thumbnailHeight*1.3;
    
    CGFloat imageViewX = self.isSelf == YES ?8.0f:12.0f;
    CGFloat imageViewY = 7.00f;
    
    self.receiveImageFrame = CGRectMake(imageViewX, imageViewY, imageViewWidth,imageViewHeight);
    
    CGFloat bubbleViewY     = 50.0f;
    CGFloat bubbleWidth     = imageViewWidth+20;
    CGFloat bubbleHeight    = imageViewHeight+15;
    CGFloat bubbleViewX     = self.isSelf == YES?DEF_SCREEN_WIDTH-80-bubbleWidth:80;
    self.bubbleViewFrame    = CGRectMake(bubbleViewX, bubbleViewY, bubbleWidth, bubbleHeight);

    self.cellHeight = bubbleViewY + bubbleHeight + 15;
}

@end
