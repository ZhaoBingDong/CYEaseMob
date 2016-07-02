//
//  UserChatBaseViewCell.h
//  环信及时通信
//
//  Created by yons on 15/10/11.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserChatCellProtocol.h"
@class ChatMessage;
@class ChatBaseFrame;

/// 气泡 cell 的基类 Cell
@interface UserChatBaseViewCell : UITableViewCell
/**
 *  iconView
 */
@property(nonatomic,strong)UIImageView *iconView;

/**
 *  dateLabel
 */
@property(nonatomic,strong)UILabel *dataLabel;

/**
 *  bubbleView
 */
@property(nonatomic,strong)UIImageView *bubbleView;
/**
 *  frame
 */
@property(nonatomic,strong)ChatBaseFrame *cellFrame;
/**
 *  nickname
 */
@property(nonatomic,strong)UILabel *nicknameLabel;

/**
 *  delete
 */
@property(nonatomic,assign)id<UserChatCellProtocol>delete;

@end
