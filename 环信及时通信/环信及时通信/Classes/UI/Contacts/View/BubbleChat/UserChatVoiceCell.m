//
//  UserChatVoiceCell.m
//  环信及时通信
//
//  Created by yons on 15/10/13.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "UserChatVoiceCell.h"
#import "ChatBaseFrame.h"
#import "ChatMessage.h"
#import "ChatMessageBodies.h"
@interface UserChatVoiceCell()
<AVAudioPlayerDelegate>
@end
@implementation UserChatVoiceCell
/// 注册一个 Cell
+ (instancetype)registUserChatVoiceCell:(UITableView*)tableView
{
    static NSString *cellID = @"UserChatVoiceCell";
    UserChatVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UserChatVoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

/// 构造方法初始化一个 Cell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       // 声音时间的 label
        self.duritionLabel   = [[UILabel alloc] init];
        self.duritionLabel.font = FOUN_SIZE(15);
        self.duritionLabel.textColor = [UIColor grayColor];
        [self.bubbleView addSubview:self.duritionLabel];
       // 声音的图片
        self.voiceImageView   = [[UIImageView alloc] init];
        [self.bubbleView addSubview:self.voiceImageView];
        [self.bubbleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVoice:)]];
    }
    return self;
}
// 重写set方法
- (void)setCellFrame:(ChatBaseFrame *)cellFrame
{
    [super setCellFrame:cellFrame];
    self.bubbleView.tag       = cellFrame.imageIndex;
    // 设置声音时间的 label 文字
    [self.duritionLabel setText:[NSString stringWithFormat:@"%ld'",(long)cellFrame.chatMessage.messagebodies.duration]];
    self.duritionLabel.textAlignment = cellFrame.isSelf == YES ?NSTextAlignmentLeft :NSTextAlignmentRight;
    [self.duritionLabel setFrame:cellFrame.duritionLabelFrame];
    // 声音气泡的图像
    [self.voiceImageView setImage:cellFrame.voiceIconImage];
    [self.voiceImageView setFrame:cellFrame.voiceIconFrame];
    /// 做动画气泡的数组
    NSArray *sendArr = @[[UIImage imageNamed:@"chat_sender_audio_playing_000.png"],[UIImage imageNamed:@"chat_sender_audio_playing_001.png"],[UIImage imageNamed:@"chat_sender_audio_playing_002.png"],[UIImage imageNamed:@"chat_sender_audio_playing_003.png"]];
    NSArray *reveiveArr = @[[UIImage imageNamed:@"chat_receiver_audio_playing000.png"],[UIImage imageNamed:@"chat_receiver_audio_playing001.png"],[UIImage imageNamed:@"chat_receiver_audio_playing002.png"],[UIImage imageNamed:@"chat_receiver_audio_playing003.png"]];
    /// 能够动画就开始动画播放音频
    if (cellFrame.canPlayVoice == YES)
    {
        self.animationImages  = cellFrame.isSelf == YES ?sendArr:reveiveArr;
        [self.voiceImageView setAnimationDuration:0.5];
        [self.voiceImageView setAnimationRepeatCount:0];
        [self.voiceImageView setAnimationImages:self.animationImages];
        [self startPlayMusic:cellFrame];
    }else
    {
        // 不能做动画的 cell 就停止播放和停止气泡动画
        if (self.player)
        {
            [self.player stop];
            self.player = nil;
        }
        // 音频会话管理者开始活动
        [[AVAudioSession sharedInstance]setActive:NO error:nil];
        // 停止动画 self.voiceImageView.animationImages 要置空 因为这是一个强引用对象 不置空为保留一份数组进行保留
        self.voiceImageView.animationImages = nil;
        [self.voiceImageView stopAnimating];
    }
}
- (void)startPlayMusic:(ChatBaseFrame*)cellFrame
{
    if (self.player) {
        [self.player stop];
        self.player = nil;
    }
    [self.voiceImageView startAnimating];
    // 创建播放器
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:cellFrame.chatMessage.messagebodies.voicelocalPath] error:nil];
    self.player.delegate    = self;
    self.player.volume      = 1;
    [self.player prepareToPlay];
    // 设置为扬声器播放
    [[AVAudioSession sharedInstance]setActive:YES error:nil];
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    [self performSelector:@selector(beginPlayRocord:) withObject:cellFrame afterDelay:0.2];
    
}
/// 开始播放录音
- (void)beginPlayRocord:(ChatBaseFrame*)frame
{
    [self.player play];
}
// 点击了语音的气泡
- (void)playVoice:(UITapGestureRecognizer*)tapView
{
    if ([self.delete respondsToSelector:@selector(userChatVoiceCell:didSelectImageAtIndexPath:)])
    {
        [self.delete userChatVoiceCell:self didSelectImageAtIndexPath:tapView.view.tag];
    }
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.player stop];
    self.player = nil;
    if ([self.delete respondsToSelector:@selector(userChatVoiceCell:didFinishedPlayVoiceAtIndexPath:)]) {
        [self.delete userChatVoiceCell:self didFinishedPlayVoiceAtIndexPath:self.bubbleView.tag];
    }
    [[AVAudioSession sharedInstance]setActive:NO error:nil];
}
@end
