//
//  UserChatVoiceCell.h
//  环信及时通信
//
//  Created by yons on 15/10/13.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "UserChatBaseViewCell.h"
#import <AVFoundation/AVFoundation.h>

/// 声音消息的 cell
@interface UserChatVoiceCell : UserChatBaseViewCell
/**
 *  animationImages
 */
@property (nonatomic,strong)NSArray  *animationImages;
/**
 *  duritionLabel
 */
@property (nonatomic,strong)UILabel  *duritionLabel;
/**
 *  voiceImageView
 */
@property (nonatomic,strong)UIImageView  *voiceImageView;

/**
 *  avplayer
 */
@property (nonatomic,strong)AVAudioPlayer  *player;

/// 注册一个 Cell
+ (instancetype)registUserChatVoiceCell:(UITableView*)tableView;

@end
