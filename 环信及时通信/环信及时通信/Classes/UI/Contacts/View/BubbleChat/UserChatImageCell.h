//
//  UserChatImageCell.h
//  环信及时通信
//
//  Created by yons on 15/10/11.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "UserChatBaseViewCell.h"

@interface UserChatImageCell : UserChatBaseViewCell
/// 接收到的 receiveImageView
@property(nonatomic,strong)UIImageView *receiveImageView;

/// 注册一个 Cell 并设置可重用标示符
+ (instancetype)registUserChatImageMessageViewCell:(UITableView*)tableView;

@end
