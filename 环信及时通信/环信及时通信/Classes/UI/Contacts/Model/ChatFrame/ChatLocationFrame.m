//
//  ChatLocationFrame.m
//  环信及时通信
//
//  Created by dabing on 15/10/12.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "ChatLocationFrame.h"
#import "ChatMessage.h"
#import "ChatMessageBodies.h"

@implementation ChatLocationFrame
- (void)setChatMessage:(ChatMessage *)chatMessage
{
    [super setChatMessage:chatMessage];
    // 显示地址信息的 label 的 frame
    CGSize  textSize            = [self.chatMessage.messagebodies.address getTextSizeWithFont:FOUN_SIZE(12) restrictWidth:150 withString:self.chatMessage.messagebodies.address];
    CGFloat addressLabelWidth   = textSize.width+40;
    CGFloat addressLabelHeight  = textSize.height+20;
    CGFloat addressLabbelX      = 0.0f;
    CGFloat addressLabely       = (addressLabelHeight*3)*0.66;
    self.addressLabelFrame      = CGRectMake(addressLabbelX, addressLabely, addressLabelWidth, addressLabelHeight);
    // 显示图片信息的 frame
    CGFloat locationViewWidth   = addressLabelWidth;
    CGFloat locationViewHeight  = addressLabelHeight*3;
    CGFloat locationViewX       = self.isSelf == YES ? 8.0f:10.0f;
    CGFloat locationViewY       = 5.0f;
    self.locationViewFrame      = CGRectMake(locationViewX, locationViewY, locationViewWidth, locationViewHeight);
    // 气泡的位置
    CGFloat bubbleViewY     = 50.0f;
    CGFloat bubbleWidth     = locationViewWidth+20;
    CGFloat bubbleHeight    = locationViewHeight+15;
    CGFloat bubbleViewX     = self.isSelf == YES?DEF_SCREEN_WIDTH-80-bubbleWidth:80;
    self.bubbleViewFrame    = CGRectMake(bubbleViewX, bubbleViewY, bubbleWidth, bubbleHeight);
    
    // 返回单元格的高度
    self.cellHeight = bubbleViewY + bubbleHeight+10;
}
@end
