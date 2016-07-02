//
//  ChatVioceFrame.m
//  环信及时通信
//
//  Created by dabing on 15/10/10.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "ChatVioceFrame.h"

@implementation ChatVioceFrame
- (void)setChatMessage:(ChatMessage *)chatMessage
{
    [super setChatMessage:chatMessage];
    // 声音时间的 label
    CGFloat duritionLabelX          = self.isSelf == YES?15.0f:50.0f;
    CGFloat duritionLabelY          = 0;
    CGFloat duritionLabebWidth      = 40;
    CGFloat duritionLabelHeight     = 36.0f;
    self.duritionLabelFrame         = CGRectMake(duritionLabelX, duritionLabelY, duritionLabebWidth, duritionLabelHeight);
    // 右边声音 icon 的 view
    CGFloat voiceIconViewX          = self.isSelf == YES?70:15.0f;
    CGFloat voiceIconViewY          = (duritionLabelHeight - 15.0f)/2;
    CGFloat voiceIconWidth          = 15.0f;
    CGFloat voiceIconHeight         = 15.0f;
    self.voiceIconImage             = self.isSelf == YES ? [UIImage imageNamed:@"chat_sender_audio_playing_full.png"]:[UIImage imageNamed:@"chat_receiver_audio_playing_full.png"];
    self.voiceIconFrame             = CGRectMake(voiceIconViewX, voiceIconViewY, voiceIconWidth, voiceIconHeight);
    // 气泡的 frame
    CGFloat bubbleViewY             = 50.0F;
    CGFloat bubbleViewWidth         = 100.0f;
    CGFloat bubbleViewHeight        = 36.0f;
    CGFloat bubbleViewX             = self.isSelf == YES?DEF_SCREEN_WIDTH-80-bubbleViewWidth:80;
    self.bubbleViewFrame            = CGRectMake(bubbleViewX, bubbleViewY, bubbleViewWidth, bubbleViewHeight);
    self.cellHeight                 = bubbleViewY +bubbleViewHeight +10;
    
}
@end
